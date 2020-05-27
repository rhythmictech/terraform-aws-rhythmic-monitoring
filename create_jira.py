import boto3
import json
from botocore.vendored import requests

def add_priority(issue, priority):
    fields = issue["fields"]
    fields["priority"] = {"name": priority}

def add_assignee(issue, assignee):
	fields = issue["fields"]
	fields["assignee"] = {"name": assignee}

def add_due_date(issue, due_date):
	fields = issue["fields"]
	fields["duedate"] = due_date

def handler(event, context):

	client = boto3.client("ssm")

	ssm_parameter_name = event["SSMParameterName"].strip()
	secret = client.get_parameter(Name=ssm_parameter_name, WithDecryption=True)['Parameter']['Value']

	username = event["JiraUsername"].strip()
	url = event["JiraURL"].strip()

	issue = {
		"fields": {
			"summary": event["IssueSummary"].strip(),
			"project": {
				"key": event["ProjectKey"].strip()
			},
			"description": event["IssueDescription"].strip(),
			"issuetype": {
				"name": event["IssueTypeName"].strip()
			}
		}
    }

	priority = event["PriorityName"].strip()
	if priority:
		add_priority(issue, priority)

	assignee = event["AssigneeName"].strip()

	if assignee:
		add_assignee(issue, assignee)

	due_date = event["DueDate"].strip()
	if due_date:
		add_due_date(issue, due_date)

	data = json.dumps(issue)

	headers = {'Content-Type':'application/json'}

	response = requests.post('{0}/rest/api/2/issue/'.format(url),
            headers=headers,
            data=data,
            auth=(username, secret))

	if not response.ok:
		raise Exception("Received error with status code " + str(response.status_code) + " from Jira")
	else:
		issue_key = (response.json()["key"])
		return {"IssueKey" : issue_key}
