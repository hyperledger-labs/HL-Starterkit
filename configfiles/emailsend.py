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
sender_email = "demo@ksmail.tech"
receiver_email = os.environ.get("TOEMLADDRESS")


port = 465  # For starttls
smtp_server = "mail.ksmail.tech"
sender_pass = '@dW!d3st28'
#sender_pass = input("Input (Sender) password to authenticate sending mails:")


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

Thanks
Support Team
KSTECH
"""
html = """\
<html>
  <body>
    <p>Hi,<br>
       Attached the Configuration files that generated for your Hyperledger fabric<br>


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
filext = 'tar.gz'
attach_file_name = os.path.join( path1, filen + "." + filext)  
#print (attach_file_name)
# Open PDF file in binary mode
with open(attach_file_name, "rb") as attachment:
    # Add file as application/octet-stream
    # Email client can usually download this automatically as attachment
    part = MIMEBase("application", "octet-stream")
    part.set_payload(attachment.read())

# Encode file in ASCII characters to send by email    
encoders.encode_base64(part)

part.add_header('Content-Decomposition', 'attachment', filename=attach_file_name)
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
    with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
        server.login(sender_email, sender_pass)
        server.sendmail(sender_email, receiver_email, text)
        print ("Successfully sent email")
        server.quit()

except SMTPException:
    print ("Error: unable to send email")
