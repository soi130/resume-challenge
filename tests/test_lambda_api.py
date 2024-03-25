
from playwright.async_api import APIRequestContext, async_playwright


async def api_request_context():
    async with async_playwright() as p:
        request_context = await p.request.new_context(base_url=\
        "https://qhq9zgl0nh.execute-api.us-east-1.amazonaws.com")
        yield request_context
        await request_context.dispose()


async def test_get_and_update_db_api(api_request_context: APIRequestContext):
    response = api_request_context.get('/write_to_dyndb')
    assert response.ok
    json_response = response.json()
    before_update_view =  json_response['before_update']['Item']['views']
    after_update_view =  json_response['before_update']['Item']['views']
    assert after_update_view == before_update_view+1
   