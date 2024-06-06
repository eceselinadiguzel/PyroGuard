from __future__ import print_function
import uuid
import requests
from datetime import datetime, timedelta
import json
import os.path
import base64
from email.mime.text import MIMEText
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

# If modifying these SCOPES, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/gmail.send']


def send_notification(locationid, camera_id, closest_ext_id, cur):
    query = """
    SELECT userid, username, sms_enabled, phone_no, email_enabled, email
    FROM users
    WHERE locationid = %s
    """
    cur.execute(query, (locationid,))
    users = cur.fetchall()

    numbers = []
    emails = []

    #hocalar = ['yucel.cimtay@tedu.edu.tr', 'gokce.yilmaz@tedu.edu.tr', 'venera.adanova@tedu.edu.tr']

    for u, username, sms_enable, phone_no, email_enable, email in users:
        if(sms_enable):
            numbers.append(phone_no)
        if(email_enable):
            emails.append(email)

    message = create_message(locationid, closest_ext_id, camera_id, cur)
    
    #send_sms(numbers, message, usernames)
    send_emails(emails, message)


def create_message(locationid, closest_ext_id, camera_id, cur):
    query = """
    SELECT location_name
    FROM locations
    WHERE locationid = %s
    """
    cur.execute(query, (locationid,))
    location_name = cur.fetchone()
    location_name = location_name[0]

    query = """
    SELECT location_description
    FROM extinguishers
    WHERE extinguisherid = %s
    """
    cur.execute(query, (closest_ext_id,))
    location_description = cur.fetchone()
    location_description = location_description[0]

    message = "FIRE DETECTED!! \n Fire in {name} from camera with id {cam_id}.\n The closest fire extinguisher is {description}. Take caution!".format(name = location_name, cam_id = camera_id, description = location_description)

    return message

def format_phone_number(numara):
    numara = numara.replace(" ", "")
    if numara[0] == "9":
        return numara
    if numara[0] == "0":
        return "9" + numara
    if numara[0] == "5":
        return "90" + numara
    return numara

def send_sms(numbers, message):

    # Define the API endpoint
    url = "https://panel4.ekomesaj.com:9588/sms/create"
    
    # Define the headers including the Basic Authorization header
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Basic Z2VyaWFyYS5jb206MTIzNDU2"
    }

    # Get the current UTC time and format it as 'yyyy-MM-ddTHH:mm:ssZ'
    sending_date = (datetime.utcnow() + timedelta(hours=3, minutes=1)).strftime('%Y-%m-%d %H:%M')
    
    for numara in numbers:

        formatted_numara = format_phone_number(numara)

        unique_custom_id = str(uuid.uuid4())
        
        # Define the payload
        payload = {
            "type": 1,
            "sendingType": 0,
            "title": "Your Title",
            "content": message,
            "number": formatted_numara,
            "encoding": 0,
            "sender": "KLIPS",
            "sendingDate": sending_date,
            "validity": 60,
            "commercial": False,
            "skipAhsQuery": True,
            "recipientType": 0,
            "customID": unique_custom_id,
            "pushSettings": {
                "url": "http://example.com/callback"  # Replace with your actual callback URL
            }
        }

        # Send the POST request
        response = requests.post(url, headers=headers, data=json.dumps(payload))

        # Parse the response
        response_data = response.json()

        # Print the response (optional, for debugging purposes)
        print(json.dumps(response_data, indent=2))

def send_emails(emails, message):

    service = authenticate_gmail_api()

    for recipient in emails:
        service = authenticate_gmail_api()

    for recipient in emails:
        raw_message = create_rawmessage('pyroguardfiredetection@gmail.com', recipient, 'FIRE DETECTED! TAKE ACTION IMMEDIATELY!', message)
        service.users().messages().send(userId='me', body=raw_message).execute()

def create_rawmessage(sender, to, subject, message_text):

    message = MIMEText(message_text)
    message['to'] = to
    message['from'] = sender
    message['subject'] = subject
    return {'raw': base64.urlsafe_b64encode(message.as_bytes()).decode()}

def authenticate_gmail_api():
    """Authenticate and return the Gmail API service."""
    creds = None
    
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'client_secret.json', SCOPES)
            creds = flow.run_local_server(port=0)

        with open('token.json', 'w') as token:
            token.write(creds.to_json())
    
    service = build('gmail', 'v1', credentials=creds)
    return service
