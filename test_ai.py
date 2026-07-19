#!/usr/bin/env python3
import urllib.request, json, re

text = '在那些被岁月打磨得温润如玉的老街巷深处，当黄昏最后一抹余晖穿过斑驳的梧桐叶隙、洒在青石板路面上泛起琥珀色的光晕时，骑着三轮车沿街叫卖了三十八年糖炒栗子的老陈，总会习惯性地停在那棵据说比他祖父的祖父还要年长的银杏树下，用他那副被炉火熏得微微沙哑却依然中气十足的嗓子，不急不缓地吆喝一声热乎的——栗子嘞——，那声音穿过炊烟袅袅的巷口、掠过邻里间此起彼伏的锅铲声和孩童嬉闹声，最终消散在逐渐亮起的万家灯火之中，仿佛这座钢筋水泥的城市在这一刻，忽然就想起了它曾经也是一座被城墙围起来的、家家户户门不闭户的小县城。'

print(f'Input: {len(text)} chars')

data = json.dumps({
    'model': 'deepseek-chat',
    'temperature': 0.3,
    'max_tokens': 4096,
    'messages': [
        {'role': 'system', 'content': '1. Translate Chinese to natural English. 2. Split the ENGLISH translation (NOT Chinese) into phrase groups of 3-6 English words. 3. Return ONLY JSON: {"translation": "...", "phrases": ["english phrase 1", "english phrase 2"]}'},
        {'role': 'user', 'content': text},
    ]
}).encode()

req = urllib.request.Request('https://api.deepseek.com/v1/chat/completions', data=data, headers={
    'Authorization': 'Bearer sk-99c25e3ea80342729809cd060b01d6a6',
    'Content-Type': 'application/json',
})

try:
    resp = json.loads(urllib.request.urlopen(req, timeout=90).read())
    content = resp['choices'][0]['message']['content'].strip()
    # Strip markdown
    content = re.sub(r'```json\s*', '', content)
    content = re.sub(r'```\s*', '', content)
    j = json.loads(content)
    print(f'OK! Translation: {len(j["translation"])} chars')
    print(f'First 200: {j["translation"][:200]}')
    print(f'Phrases ({len(j["phrases"])}):')
    for p in j['phrases'][:10]:
        print(f'  - {p}')
except Exception as e:
    print(f'FAILED: {e}')
