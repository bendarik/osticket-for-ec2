import os
from cloudflare import Cloudflare


os.environ["CLOUDFLARE_API_TOKEN"] = "SYJS4PsoO2JUflBpg-603BiLJJhYHkd_01beGyyS"
os.environ["CLOUDFLARE_ZONE_ID"] = "3e0f330a288197b6bf89a7be4084df0e"


DNS_RECORD_NAME = "baobabka.com"
PUBLIC_IP = "17.48.44.88"

dns_records = [
    {
        "type": "A",
        "name": DNS_RECORD_NAME,
        "content": PUBLIC_IP,
        "ttl": 3600,
        "proxied": False
    },
    {
        "type": "A",
        "name": "www." + DNS_RECORD_NAME,
        "content": PUBLIC_IP,
        "ttl": 3600,
        "proxied": False
    }
]

client = Cloudflare(
    api_token=os.environ.get("CLOUDFLARE_API_TOKEN"),
)
page = client.dns.records.list(
    zone_id=os.environ.get("CLOUDFLARE_ZONE_ID")
)


for record in page.result:
    matched = [x for x in dns_records if x["name"] == record.name]
    if matched.__len__() > 0:
        print(f"Record {record.name} already exists, skipping creation.")
        continue

    # print(f"Creating DNS record {record.name}...")
    # client.dns.records.post(
    #     zone_id=os.environ.get("CLOUDFLARE_ZONE_ID"),
    #     data={
    #         "type": record.type,
    #         "name": record.name,
    #         "content": record.content,
    #         "ttl": record.ttl,
    #         "proxied": record.proxied
    #     }
    # )