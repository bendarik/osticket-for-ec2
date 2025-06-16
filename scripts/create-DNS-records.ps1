
# $CLOUDFLARE_EMAIL = "bendarik@outlook.com"
# $CLOUDFLARE_API_KEY = "731edc7bb61ae713fba7c4e51f6c253dbccb7"
$CLOUDFLARE_API_TOKEN = "SYJS4PsoO2JUflBpg-603BiLJJhYHkd_01beGyyS"
$ZONE_ID = "3e0f330a288197b6bf89a7be4084df0e"
# $ACCOUNT_ID = "4f054db98163f7b86c6b3222be0e736a"


# $responce = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/user/tokens/verify" `
#     -Headers @{ "Authorization" = "Bearer $token" }

# if ($responce.StatusCode -eq 200) {
#     Write-Host "Token is valid."
#     Write-Host $responce.Content
# }


$uri = "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records";

$params = @{
    Uri     = $uri
    # Method  = "GET"
    Headers = @{ "Authorization" = "Bearer $CLOUDFLARE_API_TOKEN" }
    # Body    = @{ "name" = "{exact = 'baobabka.com'}" }
    Body    = @{ "name" = "baobabka.com" }
}

$response = Invoke-WebRequest @params

$rObj = ConvertFrom-Json $response.Content

if ($rObj.success) {
    Write-Host "DNS records retrieved successfully."
    $rObj.result | ForEach-Object {
        Write-Host "ID: $($_.id), Name: $($_.name), Type: $($_.type), Content: $($_.content)"
    }
} else {
    Write-Host "Failed to retrieve DNS records."
    Write-Host "Error: $($rObj.errors | ConvertTo-Json)"
}