#!/usr/bin/env python3
"""Archive public research sources with URL, retrieval date and content hash."""
import concurrent.futures
import datetime
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import sys
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/eis-research'


class PlainText(HTMLParser):
    def __init__(self):
        super().__init__()
        self.skip = 0
        self.parts = []

    def handle_starttag(self, tag, attrs):
        if tag in ('script', 'style', 'noscript'):
            self.skip += 1
        if tag in ('p', 'div', 'br', 'h1', 'h2', 'h3', 'li', 'tr', 'dt'):
            self.parts.append('\n')

    def handle_endtag(self, tag):
        if tag in ('script', 'style', 'noscript'):
            self.skip = max(0, self.skip - 1)

    def handle_data(self, data):
        if not self.skip:
            self.parts.append(data)


def fetch(url):
    key = hashlib.sha256(url.encode()).hexdigest()[:16]
    entry = {'url': url, 'retrieved_utc': datetime.datetime.now(datetime.timezone.utc).isoformat()}
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (public EIS research)'})
        with urllib.request.urlopen(req, timeout=35) as response:
            content = response.read()
            content_type = response.headers.get('Content-Type', '')
            entry.update(final_url=response.url, content_type=content_type, status=response.status)
        extension = '.pdf' if content.startswith(b'%PDF') else '.html' if 'html' in content_type else '.raw'
        path = OUT / 'sources' / (key + extension)
        path.write_bytes(content)
        entry.update(path=str(path.relative_to(ROOT)), sha256=hashlib.sha256(content).hexdigest(), bytes=len(content))
        if extension != '.pdf':
            text = content.decode('utf-8', errors='replace')
            if extension == '.html':
                parser = PlainText()
                parser.feed(text)
                text = '\n'.join(s.strip() for s in ''.join(parser.parts).splitlines() if s.strip())
            txtpath = path.with_suffix('.txt')
            txtpath.write_text(text)
            entry['text_path'] = str(txtpath.relative_to(ROOT))
        print(json.dumps(entry, ensure_ascii=False), flush=True)
    except Exception as exc:
        entry['error'] = str(exc)
        print(json.dumps(entry, ensure_ascii=False), flush=True)
    return entry


def main():
    (OUT / 'sources').mkdir(parents=True, exist_ok=True)
    manifest = OUT / 'sources.json'
    previous = json.loads(manifest.read_text()) if manifest.exists() else []
    records = {r['url']: r for r in previous}
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        for entry in pool.map(fetch, sys.argv[1:]):
            records[entry['url']] = entry
    manifest.write_text(json.dumps(list(records.values()), indent=2, ensure_ascii=False) + '\n')


if __name__ == '__main__':
    main()
