          $SNOWuser = '$(snow-user-prod)'
          $SNOWpass = '$(snow-pass-prod)'
          $snow_endpoint='$(snow-endpoint-prod)'

          $pair = "$($SNOWuser):$($SNOWpass)"
          $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
          $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
          $headers.Add("Authorization", "Basic $encodedCreds")
          $headers.Add("Content-Type", "application/json")

          #Create
          #"u_configuration_item"="Official Data Hubs: resources groups " + $_RG + "," + $_Orch_RG + "," + $_Orch_RG +"," + $_Vms_RG + "," + $_Inte_RG +  " build url: " + $buildUrl;
          $params=@{
              "u_action"="create";
              "u_assignment_group"="P&G_ITS_D&A_DH_CICD_PipelineSupport";
              "u_configuration_item"="Official Data Hubs resources groups $(_RG)  $_RG $_Orch_RG $_Orch_RG $_Vms_RG $_Inte_RG $build url"
              "u_service_offering"="Data Hubs";
              "u_contact_type"="auto ticket";
              "u_description"="Provisioning Infra Faliled";
              "u_impact"="3";
              "u_location"="ALL LOCATIONS";
              "u_short_description" = "provisioning failing build url $buildUrl"
              "u_urgency"="3";
              "u_category"="Enterprise Computing & Storage";
              "u_subcategory"="Azure Cloud";
              "u_problem_type"="Events, Monitoring, and Logging";
              "u_business_service"="D&A - Devops"
          }

          $uri=$snow_endpoint+"/api/now/import/u_incident"
          $response = Invoke-RestMethod $uri -Method 'POST' -Headers $headers -Body ($params|ConvertTo-Json)
          $response.result[0]

          $createInc=$response.result[0].number
