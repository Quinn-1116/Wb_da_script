from dingtalkchatbot.chatbot import DingtalkChatbot


mark_down_data = """
{color}  
*{color}*  
**{color}**  
***{color}***  
****{color}****  
*****{color}*****  
<font color=#FF0000>纯红</font>  
<font color=#FF0000>纯红</font>  
<font color=#008000>纯绿</font>   
"""
markdown_file = mark_down_data.format(color = 'mark_down格式调试')
# 测试群
webhook = "https://oapi.dingtalk.com/robot/send?access_token=2606c23eaf70851235a10785081a8fedcc72d210c9379c9b960c32d571372b8a"
secret = "SEC2fe3fce80cc0a5b2de41423c540b8f58c2f2c393a7c2ec28c75d9bdd0062939e"
xiaoding = DingtalkChatbot(webhook, secret=secret)
xiaoding.send_markdown(title='太空杀数据播报', text=markdown_file, is_at_all=False)
print("播报已发送")
