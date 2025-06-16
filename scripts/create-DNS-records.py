import os
from cloudflare import Cloudflare


os.environ["CLOUDFLARE_API_TOKEN"] = "SYJS4PsoO2JUflBpg-603BiLJJhYHkd_01beGyyS"
os.environ["CLOUDFLARE_ZONE_ID"] = "3e0f330a288197b6bf89a7be4084df0e"


DNS_RECORD_NAME = "baobabka.com"
PUBLIC_IP = "17.66.44.88"

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

# 1. Check if the DNS record already exists
page = client.dns.records.list(
    zone_id=os.environ.get("CLOUDFLARE_ZONE_ID")
)

if page.success == False:
    print(f"Failed to retrieve DNS records: {page.errors}")
else:
    print(f"Retrieved {len(page.result)} DNS records.")

    for record in page.result:
        matched = [x for x in dns_records if x["name"] == record.name]
        if matched.__len__() > 0:
            print(f"Found DNS record: {record.name}")
            
            # 2. Delete the existing DNS record.
            deletion_responce = client.dns.records.delete(
                dns_record_id=record.id,
                zone_id=os.environ.get("CLOUDFLARE_ZONE_ID")
            )
            print(f"DNS record deleted successfully: {record.name}.")

    # 3. Create a new DNS record.
    print("Creating new DNS records...")
    for record in dns_records:
        record_response = client.dns.records.create(
            zone_id=os.environ.get("CLOUDFLARE_ZONE_ID"),
            name=record["name"],
            type=record["type"],
            content=record["content"],
            ttl=record["ttl"],
            proxied=record["proxied"]
        )
        print(f"DNS record created successfully: {record['name']}.")
