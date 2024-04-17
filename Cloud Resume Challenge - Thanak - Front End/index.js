

// old API = 'https://qhq9zgl0nh.execute-api.us-east-1.amazonaws.com/write_to_dyndb'
// new TF API = 'https://jtq7yd6y81.execute-api.us-east-1.amazonaws.com/terraform_lambda_write_to_dyndb'
fetch('https://jtq7yd6y81.execute-api.us-east-1.amazonaws.com/terraform_lambda_write_to_dyndb', {
        method: 'GET',

    })
    .then(response => {
        console.log(response)
        console.info(response.status);
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        // Handle the data received from the API
        console.log('Data from API:', data);
        console.log('Data from API >> focus test', data.after_update.Item.views)
        current_view_count = data.after_update.Item.views;
        // Update the visitorCount element with the received count
        document.getElementById('visitorCount').textContent = current_view_count;
    })
    .catch(error => {
        // Handle errors that occurred during fetch
        console.error('Fetch error:', error);
    });
