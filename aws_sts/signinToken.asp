<%
FUNCTION LoadThePage(strPageText, strInputURL)
	Set objXMLHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP")
	objXMLHTTP.Open "GET", strInputURL, False
	objXMLHTTP.Send
	strPageText = objXMLHTTP.responseText
	Set objXMLHTTP = Nothing
End FUNCTION
signinUrl = "https://signin.aws.amazon.com/federation?Action=getSigninToken&SessionType=json&Session=" & Request.Form("encoded_session_string")
LoadThePage signInToken, signinUrl
signInToken = Replace(signInToken, """}", "")
signInToken = Replace(signInToken, "{""SigninToken"":""", "")
loginUrl = "https://signin.aws.amazon.com/federation?Action=login&Issuer=https%3A%2F%2F"&Request.ServerVariables("SERVER_NAME") &"&Destination=https%3A%2F%2Fconsole.aws.amazon.com&SigninToken=" & signInToken
Response.Redirect loginUrl
%>
