const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Read environment variables
const color = process.env.APP_COLOR || 'blue';
const version = process.env.APP_VERSION || '1.0.0';

app.get('/', (req, res) => {
    // Generate a simple HTML page based on the color
    const bgColor = color.toLowerCase() === 'green' ? '#4caf50' : '#2196f3';
    
    res.send(`
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Blue-Green Deployment App</title>
            <style>
                body {
                    background-color: ${bgColor};
                    color: white;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    height: 100vh;
                    margin: 0;
                }
                .container {
                    text-align: center;
                    background: rgba(0, 0, 0, 0.2);
                    padding: 40px;
                    border-radius: 10px;
                    box-shadow: 0 4px 6px rgba(0,0,0,0.3);
                }
                h1 {
                    font-size: 3rem;
                    margin-bottom: 10px;
                    text-transform: capitalize;
                }
                p {
                    font-size: 1.5rem;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>${color} Environment Active</h1>
                <p>Application Version: <strong>${version}</strong></p>
                <p>Serving from Docker Container</p>
            </div>
        </body>
        </html>
    `);
});

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'UP', color: color, version: version });
});

app.listen(port, () => {
    console.log(`App (${color}) listening at http://localhost:${port}`);
});
