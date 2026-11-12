class API(object):
    def __init__(self):
        self.sock = socket.create_connection(('127.0.0.1', 7878), 2)
        self.sock.settimeout(0.25)
        self.buffer = ''
        self.decoder = json.JSONDecoder()
        self.token = 0

    def event(self, direction, message):
        safe = dict(message)
        safe.pop('token', None)
        if safe.get('msg_id') == 257:
            safe.pop('param', None)
        if safe.get('msg_id') == 3 and isinstance(safe.get('param'), list):
            safe['param'] = {k:v for row in safe['param'] for k,v in row.items() if k in SETTINGS}
        events.append({'direction':direction,'uptime':open('/proc/uptime').read().split()[0],
                       'message':safe})

    def call(self, msg_id, timeout=1.5, **args):
        message = dict(msg_id=msg_id, token=self.token, **args)
        self.event('send', message)
        self.sock.sendall(json.dumps(message).encode('utf-8'))
        deadline = time.time()+timeout
        while time.time()<deadline:
            self.buffer = self.buffer.lstrip()
            if self.buffer:
                try:
                    row,end = self.decoder.raw_decode(self.buffer)
                except ValueError:
                    pass
                else:
                    self.buffer = self.buffer[end:]
                    self.event('receive',row)
                    if row.get('msg_id')==msg_id and 'rval' in row:
                        return row
                    continue
            try:
                data=self.sock.recv(65536)
            except socket.timeout:
                continue
            if not data:
                raise RuntimeError('Camera API disconnected')
            self.buffer += data.decode('utf-8')
        raise RuntimeError('Camera API response deadline: '+str(msg_id))
