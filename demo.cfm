<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

    <cfschedule
        action="update"
        task="BirthdayMail"
        operation="HTTPRequest"
        startDate="#dateFormat(now())#"
        url="http://contactsbook.com/test1.cfm"
        interval="daily"
        repeat="1" />
</body>
</html>