import os,stat,hashlib,json,subprocess,base64
probe=json.loads(base64.b64decode((
    'eyJhdXRvZXhlY19zaGEyNTYiOiAiZDI0MzJjNmNjYjBkMjJiMjUxMWFlNjY0ODNmMTkxYjc3MWU1Njcz'
    'MThhODI0MDE2NmI0ZDk4MThiNzhkMTFhNSIsICJiZWdpbiI6ICIvdG1wL3lpNGtfc2hhcmVwdl8yZmY4'
    'MjM4YjFiYjZfYmVnaW4iLCAiZGlzYWJsZV9hZnRlciI6ICIvdG1wL3lpNGtfc2hhcmVwdl8yZmY4MjM4'
    'YjFiYjZfZGlzYWJsZV9hZnRlciIsICJkb25lIjogIi90bXAveWk0a19zaGFyZXB2XzJmZjgyMzhiMWJi'
    'Nl9kb25lIiwgImVuYWJsZV9hZnRlciI6ICIvdG1wL3lpNGtfc2hhcmVwdl8yZmY4MjM4YjFiYjZfZW5h'
    'YmxlX2FmdGVyIiwgImlkZW50aWZpZXIiOiAiMmZmODIzOGIxYmI2IiwgImluaXRfYWZ0ZXIiOiAiL3Rt'
    'cC95aTRrX3NoYXJlcHZfMmZmODIzOGIxYmI2X2luaXRfYWZ0ZXIiLCAibWFya2VyIjogIi90bXAvU0Qw'
    'L2F1dG9leGVjLmFzaCIsICJwYXlsb2FkcyI6IHsiYXV0b2V4ZWMiOiAiZENCcGNHTWdjbkJqSUdOc2Ju'
    'UWdaWGhsWXpFZ0ozUnZkV05vSUM5MGJYQXZlV2swYTE5emFHRnlaWEIyWHpKbVpqZ3lNemhpTVdKaU5s'
    'OWlaV2RwYmljS2RDQmhjSEFnZEdWemRDQnphR0Z5WlhCMklHbHVhWFFLZENCcGNHTWdjbkJqSUdOc2Ju'
    'UWdaWGhsWXpFZ0ozUnZkV05vSUM5MGJYQXZlV2swYTE5emFHRnlaWEIyWHpKbVpqZ3lNemhpTVdKaU5s'
    'OXBibWwwWDJGbWRHVnlKd3AwSUdsd1l5QnljR01nWTJ4dWRDQmxlR1ZqTVNBbmNIbDBhRzl1SUM5MGJY'
    'QXZVMFF3TDNscE5HdGZjMmhoY21Wd2RsOHlabVk0TWpNNFlqRmlZalpmY25CakxuQjVJR2x1YVhRbkNu'
    'UWdZWEJ3SUhSbGMzUWdjMmhoY21Wd2RpQmxiZ3AwSUdsd1l5QnljR01nWTJ4dWRDQmxlR1ZqTVNBbmRH'
    'OTFZMmdnTDNSdGNDOTVhVFJyWDNOb1lYSmxjSFpmTW1abU9ESXpPR0l4WW1JMlgyVnVZV0pzWlY5aFpu'
    'UmxjaWNLZENCcGNHTWdjbkJqSUdOc2JuUWdaWGhsWXpFZ0ozQjVkR2h2YmlBdmRHMXdMMU5FTUM5NWFU'
    'UnJYM05vWVhKbGNIWmZNbVptT0RJek9HSXhZbUkyWDNKd1l5NXdlU0JsYm1GaWJHVW5DblFnWVhCd0lI'
    'UmxjM1FnYzJoaGNtVndkaUJrYVhNS2RDQnBjR01nY25CaklHTnNiblFnWlhobFl6RWdKM1J2ZFdOb0lD'
    'OTBiWEF2ZVdrMGExOXphR0Z5WlhCMlh6Sm1aamd5TXpoaU1XSmlObDlrYVhOaFlteGxYMkZtZEdWeUp3'
    'cDBJR2x3WXlCeWNHTWdZMnh1ZENCbGVHVmpNU0FuY0hsMGFHOXVJQzkwYlhBdlUwUXdMM2xwTkd0ZmMy'
    'aGhjbVZ3ZGw4eVptWTRNak00WWpGaVlqWmZjbkJqTG5CNUlHUnBjMkZpYkdVbkNuUWdhWEJqSUhKd1l5'
    'QmpiRzUwSUdWNFpXTXhJQ2QwYjNWamFDQXZkRzF3TDNscE5HdGZjMmhoY21Wd2RsOHlabVk0TWpNNFlq'
    'RmlZalpmWkc5dVpTY0siLCAicnBjX3NvdXJjZSI6ICJhVzF3YjNKMElHTjBlWEJsY3lCaGN5QkRMQ0Jx'
    'YzI5dUxDQnZjeXdnYzNsekxDQm9ZWE5vYkdsaUxDQnphV2R1WVd3S2MybG5ibUZzTG1Gc1lYSnRLRGdw'
    'Q25Cb1lYTmxQWE41Y3k1aGNtZDJXekZkQ214cFluQmhkR2c5Snk5MWMzSXZiR2xpTDJ4cFltRnRZbUZw'
    'Y0dNdWMyOG5DbXhwWWoxRExrTkVURXdvYkdsaWNHRjBhQ2tLYkdsaUxtRnRZbUZwY0dOZlkyeHVkRjlq'
    'Y21WaGRHVXVZWEpuZEhsd1pYTTlXME11WTE5MWFXNTBNeklzUXk1algzVnBiblF6TWl4RExtTmZkV2x1'
    'ZERNeVhUc2diR2xpTG1GdFltRnBjR05mWTJ4dWRGOWpjbVZoZEdVdWNtVnpkSGx3WlQxRExtTmZkbTlw'
    'WkY5d0NteHBZaTVoYldKaGFYQmpYMk5zYm5SZlkyRnNiQzVoY21kMGVYQmxjejFiUXk1algzWnZhV1Jm'
    'Y0N4RExtTmZkV2x1ZERNeUxFTXVZMTkyYjJsa1gzQXNReTVqWDNWcGJuUXpNaXhETG1OZmRtOXBaRjl3'
    'TEVNdVkxOTFhVzUwTXpJc1F5NWpYM1ZwYm5Rek1sMDdJR3hwWWk1aGJXSmhhWEJqWDJOc2JuUmZZMkZz'
    'YkM1eVpYTjBlWEJsUFVNdVkxOXBiblFLYkdsaUxtRnRZbUZwY0dOZlkyeHVkRjlrWlhOMGNtOTVMbUZ5'
    'WjNSNWNHVnpQVnRETG1OZmRtOXBaRjl3WFRzZ2JHbGlMbUZ0WW1GcGNHTmZZMnh1ZEY5a1pYTjBjbTk1'
    'TG5KbGMzUjVjR1U5UXk1algybHVkQXBqUFd4cFlpNWhiV0poYVhCalgyTnNiblJmWTNKbFlYUmxLREVz'
    'TUhneE1EQXdNREF3WXl3eEtRcHlQWHNuY0doaGMyVW5PbkJvWVhObExDZHNhV0p5WVhKNVgzTm9ZVEkx'
    'TmljNmFHRnphR3hwWWk1emFHRXlOVFlvYjNCbGJpaHNhV0p3WVhSb0xDZHlZaWNwTG5KbFlXUW9LU2t1'
    'YUdWNFpHbG5aWE4wS0NsOUNtbG1JRzV2ZENCak9nb2djbHNuWTJ4cFpXNTBKMTA5SjI1MWJHd25DbVZz'
    'YzJVNkNpQnpQVU11WTE5MWFXNTBNeklvTUhoa1pXRmtZbVZsWmlrN0lISmJKM04wWVhSMWMxOXlZeWRk'
    'UFd4cFlpNWhiV0poYVhCalgyTnNiblJmWTJGc2JDaGpMRE1zVG05dVpTd3dMRU11WW5seVpXWW9jeWtz'
    'TkN3eE1EQXdLVHNnY2xzbmMzUmhkSFZ6SjEwOWN5NTJZV3gxWlFvZ2FXWWdjbHNuYzNSaGRIVnpYM0pq'
    'SjEwOVBUQTZDaUFnYVc1bWJ6MG9ReTVqWDNWcGJuUXpNaW8yS1NncVd6QjRaR1ZoWkdKbFpXWmRLallw'
    'T3lCeVd5ZHRaVzFwYm1adlgzSmpKMTA5YkdsaUxtRnRZbUZwY0dOZlkyeHVkRjlqWVd4c0tHTXNNU3hP'
    'YjI1bExEQXNReTVpZVhKbFppaHBibVp2S1N3eU5Dd3hNREF3S1RzZ2Nsc25iV1Z0YVc1bWIxOTFNeklu'
    'WFQxc2FYTjBLR2x1Wm04cENpQnlXeWRrWlhOMGNtOTVYM0pqSjEwOWJHbGlMbUZ0WW1GcGNHTmZZMnh1'
    'ZEY5a1pYTjBjbTk1S0dNcENuUnllVG9LSUc5c1pEMXFjMjl1TG14dllXUW9iM0JsYmlnbkwzUnRjQzlU'
    'UkRBdmVXazBhMTl6YUdGeVpYQjJYekptWmpneU16aGlNV0ppTmw5eWNHTmZjbVZ6ZFd4MExtcHpiMjRu'
    'S1NrS1pYaGpaWEIwT2dvZ2IyeGtQVnRkQ205c1pDNWhjSEJsYm1Rb2Npa0tabVE5YjNNdWIzQmxiaWdu'
    'TDNSdGNDOVRSREF2ZVdrMGExOXphR0Z5WlhCMlh6Sm1aamd5TXpoaU1XSmlObDl5Y0dOZmNtVnpkV3gw'
    'TG1wemIyNG5MRzl6TGs5ZlYxSlBUa3haZkc5ekxrOWZRMUpGUVZSOGIzTXVUMTlVVWxWT1F5d3dOakF3'
    'S1FwdmN5NTNjbWwwWlNobVpDeHFjMjl1TG1SMWJYQnpLRzlzWkN4emIzSjBYMnRsZVhNOVZISjFaU2tw'
    'Q205ekxtTnNiM05sS0daa0tRcHdjbWx1ZENnbldVbGZVMGhCVWtWUVZsOVNVRU1nSnl0cWMyOXVMbVIx'
    'YlhCektISXNjMjl5ZEY5clpYbHpQVlJ5ZFdVcEtRbz0ifSwgInJwY19yZXN1bHQiOiAiL3RtcC9TRDAv'
    'eWk0a19zaGFyZXB2XzJmZjgyMzhiMWJiNl9ycGNfcmVzdWx0Lmpzb24iLCAicnBjX3NjcmlwdCI6ICIv'
    'dG1wL1NEMC95aTRrX3NoYXJlcHZfMmZmODIzOGIxYmI2X3JwYy5weSIsICJycGNfc2NyaXB0X3NoYTI1'
    'NiI6ICI4MTFkZGI1MDc1MWZhNTAyYjM3YTRiZDEyNDliZDUzYWUwOTM5YTNkYmVjMzkwYzIxNTE2YTJj'
    'MDA1YzNmZmRmIiwgInN0ZW0iOiAieWk0a19zaGFyZXB2XzJmZjgyMzhiMWJiNiJ9'
)))
names=(probe['marker'],probe['rpc_script'],probe['rpc_result'],
 probe['begin'],probe['init_after'],probe['enable_after'],
 probe['disable_after'],probe['done'])
for n in names:
 assert not os.path.lexists(n),'refuse existing '+n
for key,path in [('autoexec',probe['marker']),('rpc_source',probe['rpc_script'])]:
 data=base64.b64decode(probe['payloads'][key])
 fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0600)
 with os.fdopen(fd,'wb') as f:f.write(data)
 expected=probe['autoexec_sha256'] if key=='autoexec' else probe['rpc_script_sha256']
 assert hashlib.sha256(open(path,'rb').read()).hexdigest()==expected
subprocess.check_call(['sync'])
print('YI_SHAREPV_STAGE '+json.dumps({'created_exclusively':True}))
