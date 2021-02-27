# WORK IN PROGRESS, please move on

# AWS STS on Chrome Plugin for CyberArk PSM

## Usage
This PSM plugin will allow users to log on to AWS Management Console on Console using AWS STS

## How does it work?

1. Using [Web Applications for PSM](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PASIMP/psm_WebApplication.htm?tocpath=Developer%7CCreate%20extensions%7CPSM%20Connectors%7C_____2), the necessary info for generating the federation link is pass the web app, that comes with this plugin, hosted on local component server
2. The assumeRole API from [AWS Javascript SDK](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/STS.html#assumeRole-property), an encoded session token for temporary, limited-privilege credentials is generated
3. The encoded session token is passed to the signinToken.asp page to get the Sign In token, as well as the federation login URL
4. The user will be redirected to the federation login URL to complete the AWS STS signin process


## Setup Procedure

### System & Platform setup
1. Copy `/aws_sts` from this repo to `c:\inetpub\wwwroot\` folder on PSM Server

2. In PVWA, follow the steps in offical doc to create a new [web application for PSM](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PASIMP/psm_WebApplication.htm?tocpath=Developer%7CCreate%20extensions%7CPSM%20Connectors%7C_____2#Configuration) with the following configuration:

Properties|Value
----------|-----
ID| PSM-AwsStsChrome
Target Settings/ClientApp|Chrome 
Web Form Settings\LogonURL|http://localhost/aws_sts/
Web Form Settings\WebFormFields|access_key>{AWSAccessKeyID}</br>secret_key>{Password}</br>account_id>{AWSAccountID}</br>arn_role>{AWSArnRole}</br>policy>{AWSPolicy}</br>duration>{AWSDuration}</br>next_button>(Button)

3. Add the following new user parameter under `User Parameters` of the newly created `PSM-AwsStsChrome` web application for PSM
Name|Value
----|-----
Name|AWSDuration
DisplayName|Session Duration (Seconds)
Value|3600
Visible|Yes
Required|Yes

3. In PVWA, go to administration > platform management to [duplicate platform](https://docs.cyberark.com/Product-Doc/OnlineHelp/PrivCloud/Latest/en/Content/PASIMP/manage-platforms.htm) `Amazon Web Services (AWS) Access Keys` to new platform `AWS STS with Acess Keys`

4. Edit the newly created platform `AWS STS with Acess Keys` with the following changes:

   - Add `AWSPolicy`, `AWSArnRole`, `AWSDuration` under `Target Account Platform > UI & Workflow > Properties > Required`
Name|Value
----|-----
AWSPolicy|AWS Policy
AWSArnRole|AWS ARN Role
AWSDuration|AWS Session Duration

   - Add a new `Connection Componments` with `PSM-AwsStsChrome` as `Id`


### Acccount Setup




## Design Consideration
1. Why not following the standard 2 AWS account setup?

   The offical AWS setup requires a logon account with a custom property.    
   As of 2021 Feb, it is not supported by neither [custom universal connector](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PASIMP/psm_Develop_universal_connector.htm?TocPath=Developer%7CCreate%20extensions%7CPSM%20Connectors%7C_____1) nor  [Web Applications for PSM](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PASIMP/psm_WebApplication.htm?tocpath=Developer%7CCreate%20extensions%7CPSM%20Connectors%7C_____2)

2. Why using both JavaScript & ASP?

   The aim here is leverage on language supported on IIS from the standard component setup.
   ASP.NET or ASP.NET core is not considered due to the complexity on web app deployment.
   AWS JavaScript SDK works great for getting session token, but will cause CORS issues when it comes to getting the signin token, hence ASP is used 
