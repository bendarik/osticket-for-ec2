
$CLOUDFLARE_API_TOKEN = "SYJS4PsoO2JUflBpg-603BiLJJhYHkd_01beGyyS"
$ZONE_ID = "3e0f330a288197b6bf89a7be4084df0e"

$uri = "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records";

# Define the DNS record details

$DNS_RECORD_NAME = "baobabka.com"
$PUBLIC_IP = "17.48.44.77"

$DNS_RECORDS = @(
    @{
        type    = "A"
        name    = $DNS_RECORD_NAME
        content = $PUBLIC_IP
        ttl     = 3600
        proxied = $false
    },
    @{
        type    = "A"
        name    = "www.$($DNS_RECORD_NAME)"
        content = $PUBLIC_IP
        ttl     = 3600
        proxied = $false
    }
)

#
# 1. Check if the DNS record already exists
$records_response = Invoke-WebRequest `
    -Uri $uri `
    -Method Get `
    -Headers @{ "Authorization" = "Bearer $CLOUDFLARE_API_TOKEN" }
$records_result = ConvertFrom-Json $records_response.Content
if ($records_result.success) {
    
    #
    # 2. Delete the existing DNS record.
    $records_result.result | ForEach-Object {
        if ($_.name -eq $DNS_RECORD_NAME -or $_.name -eq "www.$($DNS_RECORD_NAME)") {
            
            Write-Host "Found DNS record: $($_.name) (id $($_.id))"

            $delete_response = Invoke-WebRequest `
                -Uri "$($uri)/$($_.id)" `
                -Method Delete `
                -Headers @{ "Authorization" = "Bearer $CLOUDFLARE_API_TOKEN" }
            $delete_result = ConvertFrom-Json $delete_response.Content
            if ($delete_result.success) {
                Write-Host "DNS record deleted successfully: $($_.name) (id $($_.id))"
            }
            else {
                Write-Host "Failed to delete DNS record: $($_.name) (id $($_.id))"
                Write-Host "Error: $($delete_result.errors | ConvertTo-Json)"
            }
        }
    }

    #
    # 3. Create new DNS records.
    foreach ($record in $DNS_RECORDS) {
        $jsonBody = $record | ConvertTo-Json -Depth 3
        try {
            $create_response = Invoke-WebRequest `
                -Uri $uri `
                -Method Post `
                -Headers @{ "Authorization" = "Bearer $CLOUDFLARE_API_TOKEN" } `
                -ContentType "application/json" `
                -Body $jsonBody
            $create_result = ConvertFrom-Json $create_response.Content
            if ($create_result.success) {
                Write-Host "DNS record created successfully: $($record.name)"
            }
            else {
                Write-Host "Failed to create DNS record: $($record.name)"
                Write-Host "Error: $($delete_result.errors | ConvertTo-Json)"
            }
        }
        catch {
            Write-Host "Exception creating DNS record: $($record.name)"
            Write-Host $_.Exception.Message
        }
    }
}
else {
    Write-Host "Failed to retrieve DNS records."
    Write-Host "Error: $($records_result.errors | ConvertTo-Json)"
}