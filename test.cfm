<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    xcvbnjklllm
    <cfschedule
            mode="application"
            action="update"
            task="#session.userDetails.emailID#-BirthdayMail"
            operation="HTTPRequest"
            startDate="#dateFormat(now())#"
            startTime="12:28 AM"
            url="http://contactsbook.com/demo.cfm"
            interval="daily" />
</body>
</html>
