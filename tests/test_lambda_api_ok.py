#%%
import requests

URL = "https://jtq7yd6y81.execute-api.us-east-1.amazonaws.com"
ENDPOINT = '/terraform_lambda_write_to_dyndb'

#%%

def test_api_ok():
    response = requests.get(URL+ENDPOINT)
    assert response.status_code == 200

# %%
