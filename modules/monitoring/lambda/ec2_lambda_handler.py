import os

import boto3
from discord_webhook import DiscordWebhook

discord_webhook_url = os.environ['DISCORD_WEBHOOK_URL']

webhook = DiscordWebhook(url=discord_webhook_url)

region = 'us-east-1'
ec2 = boto3.client('ec2', region_name=region)
response = ec2.describe_instances(Filters=[
    {
        'Name': 'tag:Name',
        'Values': [
                'FoundryVTT',
        ]
    },
])

instances = []

for reservation in response["Reservations"]:
    for instance in reservation["Instances"]:
        instances.append(instance["InstanceId"])


def send_notification(message):
    webhook.content = message
    webhook.execute()


def stop(event, context):
    ec2.stop_instances(InstanceIds=instances)
    send_notification("Fechando Foundry")
    print('stopped instances: ' + str(instances))


def start(event, context):
    ec2.start_instances(InstanceIds=instances)
    send_notification("Abrindo Foundry")
    print('started  instances: ' + str(instances))
