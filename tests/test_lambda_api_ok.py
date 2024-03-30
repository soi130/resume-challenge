#%%
import requests
import pytest

URL = "https://qhq9zgl0nh.execute-api.us-east-1.amazonaws.com"
ENDPOINT = '/write_to_dyndb'

#%%

def test_api_ok():
    response = requests.get(URL+ENDPOINT)
    assert response.status_code == 200

# %%
