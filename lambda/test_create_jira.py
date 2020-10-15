import create_jira


test_event = {"Records": [{
    "EventSource": "aws:sns",
    "EventVersion": "1.0",
    "EventSubscriptionArn": "arn:aws:sns:us-east-1:312594956781:ENG-1332-Ticket-Topic:f645abcd-548c-4735-87fd-4f9ebf6891a6",
    "Sns": {
        "Type": "Notification",
        "MessageId": "09652ef4-873d-5bf9-a715-76f6dc0771c5",
        "TopicArn": "arn:aws:sns:us-east-1:312594956781:ENG-1332-Ticket-Topic",
        "Subject": "ALARM: \"eng-1332\" in US East (N. Virginia)",
        "Message": "{\"AlarmName\":\"eng-1332\",\"AlarmDescription\":null,\"AWSAccountId\":\"312594956781\",\"NewStateValue\":\"ALARM\",\"NewStateReason\":\"Threshold Crossed: 1 out of the last 1 datapoints [424.2 (14/10/20 14:13:00)] was greater than the threshold (1.0) (minimum 1 datapoint for OK -> ALARM transition).\",\"StateChangeTime\":\"2020-10-15T14:13:14.090+0000\",\"Region\":\"US East (N. Virginia)\",\"AlarmArn\":\"arn:aws:cloudwatch:us-east-1:312594956781:alarm:eng-1332\",\"OldStateValue\":\"INSUFFICIENT_DATA\",\"Trigger\":{\"MetricName\":\"EstimatedCharges\",\"Namespace\":\"AWS/Billing\",\"StatisticType\":\"Statistic\",\"Statistic\":\"MAXIMUM\",\"Unit\":null,\"Dimensions\":[{\"value\":\"USD\",\"name\":\"Currency\"}],\"Period\":86400,\"EvaluationPeriods\":1,\"ComparisonOperator\":\"GreaterThanThreshold\",\"Threshold\":1.0,\"TreatMissingData\":\"- TreatMissingData:                    missing\",\"EvaluateLowSampleCountPercentile\":\"\"}}",
        "Timestamp": "2020-10-15T14:13:14.338Z",
        "SignatureVersion": "1",
        "Signature": "iKSWZ3+yPnyJPXlW5Zn+TfgDgh8bwdSo7P9AlnqVvyFc64siie9kZEwlmhhaDvYdvqcPQEBzdIiZYZJyw39Z1lTtnGUNKqn9Ii5GKf19jyfFxdxzUOnuh74hF1SWOJOlv7xsRLMW58XOTpJHgXWDX1kR7cngaY3fW7m2GuWMZVY8ubNwPZgNw+sduT8RUkMcdBEjNBDNz2XHyNrV1saQal/AyuVSycaioynqxk9Q9LbhRJeerAaPG4dH05YadyT+zC1OeFxlcsYMnTJ1mDXrxmkc9AgZdu8QlGR1NBr+eRASHZt1LPr44ZFcIKvlIJ2WSVusyHkrxOeImBU3SupdOg==",
        "SigningCertUrl": "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-a86cb10b4e1f29c941702d737128f7b6.pem",
        "UnsubscribeUrl": "https://sns.us-east-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-1:312594956781:ENG-1332-Ticket-Topic:f645abcd-548c-4735-87fd-4f9ebf6891a6",
        "MessageAttributes": {}
    }
}]}

create_jira.lambda_handler(test_event, {})
