const http = require('http');
const os = require('os');

const server = http.createServer((req, res) => {
    
    if (req.url === '/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ status: 'healthy', timestamp: new Date() }));
        return;
    }

    const dashboardData = {
        project: "Enterprise Migration Factory",
        version: process.env.APP_VERSION || "1.0.0",
        environment: process.env.ENVIRONMENT || "dev",
        status: "Running",
        container_host: os.hostname(),
        migrations_completed: 400,
        infrastructure: {
            provisioner: "Terraform",
            cloud: "Microsoft Azure",
            pipeline: "Jenkins"
        }
    };

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(dashboardData, null, 2));
});

server.listen(3000, () => {
    console.log('Migration Dashboard running on port 3000');
});