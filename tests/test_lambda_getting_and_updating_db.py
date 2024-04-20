#%%
import requests

URL = "https://jtq7yd6y81.execute-api.us-east-1.amazonaws.com"
ENDPOINT = '/terraform_lambda_write_to_dyndb'

#%%

def test_api_get_and_rewrite_db():
    response = requests.get(URL+ENDPOINT)
    assert response.status_code == 200
    json_response = response.json()
    before_update_view =  json_response['before_update']['Item']['views']
    after_update_view =  json_response['after_update']['Item']['views']
    assert after_update_view == before_update_view+1

# %%
