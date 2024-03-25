


fetch('https://qhq9zgl0nh.execute-api.us-east-1.amazonaws.com/write_to_dyndb', {
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
        current_view_count = data.after_update.Item.views;
        // Update the visitorCount element with the received count
        document.getElementById('visitorCount').textContent = current_view_count;
    })
    .catch(error => {
        // Handle errors that occurred during fetch
        console.error('Fetch error:', error);
    });
