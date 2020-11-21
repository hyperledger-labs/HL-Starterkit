import email, smtplib, ssl, os

from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


##Loading Environment 

with open('.hlc.env', 'r') as fh:
    
    vars_dict = dict(
        tuple(line.split('='))
        for line in fh.readlines() if not line.startswith('#')

    )

#print(vars_dict)
os.environ.update(vars_dict)

subject = "Mail generated through fabric configrator tool"
body = "Attached Configuration files in tar.gz format ="
receiver_email = os.environ.get("TOEMLADDRESS")

### gmail
#sender_email = 'kstechio2019@gmail.com'
#smtp_server = "smtp.gmail.com"
#sender_pass = 'kstech@369'

### hostinger email
#sender_email = 'support@blog.knowledgesociety.tech'
#smtp_server = 'smtp.hostinger.in'
#sender_pass = '6k:yid6xe8P#'



### mailgun
#sender_email = "postmaster@blog.knowledgesociety.tech"
#smtp_server = "smtp.eu.mailgun.org"
#sender_pass = 'eae68b91cd2c7ed7e7217d75d6ed2a61-ea44b6dc-2dc6d04f'
#sender_pass = input("Input (Sender) password to authenticate sending mails:")

### ksmail
sender_email = 'support@ksmail.tech'
smtp_server = 'mail.ksmail.tech'
sender_pass = 'support123'

port = 587 # For starttls

# Create a multipart message and set headers
message = MIMEMultipart()
message["From"] = sender_email
message["To"] = receiver_email
message["Subject"] = subject
message["Bcc"] = receiver_email  # Recommended for mass emails

# Create the plain-text and HTML version of your message
text = """\
Hi,
Attached the Configuration files that generated for your Hyperledger fabric 

Note : If you received as unname attachment, pls rename to {somename}.tar.gz

Thanks
Support Team
KSTECH
"""
html = """\
<html>
  <body>
    <p>Hi,<br>
       Attached the Configuration files that generated for your Hyperledger fabric<br>

Note : If you received as unname attachment, pls rename to {somename}.tar.gz

Thanks
Support Team
KSTECH
    </p>
  </body>
</html>
"""


# Add body to email
message.attach(MIMEText(text, "plain"))
#message.attach(MIMEText(html, "html")
filen = os.environ.get("DOMAIN_NAME").replace('\n','')
path1= '/tmp/'
filext = '.tar.gz'
file_name = os.path.join( path1, filen + filext)  
attach_file_name = os.path.join(filen)  
#print (attach_file_name)
# Open PDF file in binary mode
with open(file_name, "rb") as attachment:
    # Add file as application/octet-stream
    # Email client can usually download this automatically as attachment
    part = MIMEBase("application", "x-gzip")
    part.set_payload(attachment.read())

# Encode file in ASCII characters to send by email    
encoders.encode_base64(part)

part.add_header('Content-Decomposition', "attachment; filename=\"%s.tar.gz\"" % (attach_file_name))
message.attach(part)




# Turn these into plain/html MIMEText objects
part1 = MIMEText(text, "plain")
part2 = MIMEText(html, "html")

# Add HTML/plain-text parts to MIMEMultipart message
# The email client will try to render the last part first
#message.attach(part1)
#message.attach(part2)



# Add attachment to message and convert message to string
#message.attach(part)
text = message.as_string()




# Log in to server using secure context and send email
context = ssl.create_default_context()
try :
    with smtplib.SMTP(smtp_server, port) as server:
        server.starttls(context=context)
        server.login(sender_email, sender_pass)
        server.sendmail(sender_email, receiver_email, text)
        print ("Successfully sent email")
        server.quit()

except smtplib.SMTPException as e :
    print ("Error: unable to send email", e )
