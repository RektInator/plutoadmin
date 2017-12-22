const fs = require("fs");
const request = require("snekfetch");


fs.watchFile("./report.json", function() {
    var json = JSON.parse(fs.readFileSync("./report.json", "utf8"));
    request.post(json.webhook)
        .send({
            "embeds": [
                {
                    "type": "rich",
                    "timestamp": new Date(),
                    "color": 16193046,
                    "fields": [
                        {
                            "name": "Server Name",
                            "value": json.server_name,
                            "inline": false
                        },
                        {
                            "name": "Report By",
                            "value": json.reporter,
                            "inline": false
                        },
                        {
                            "name": "Message",
                            "value": json.message,
                            "inline": false
                        }
                    ]
                }
            ]
        })
        .then(r => console.log(r.body));
});