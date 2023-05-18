import fastify from "fastify";
import auth from "fastify-auth0-verify";
import "dotenv/config";

const app = fastify();

//AUDIENCE -> Auth0 Dashboard - API
//DOMAIN and ISSUER -> Auth0 Dashboard - Application

//From repoonse:
//request.user SUB -> auth0|<userid>

async function setRegister() {
    await app.register(auth, {
        audience: process.env.AUTH_AUDIENCE,
        domain: process.env.AUTH_DOMAIN,
        issuer: process.env.AUTH_ISSUER,
    })

    app.get('/private', { preValidation: app.authenticate }, (request, reply) => {
        console.log("VALIDATED")
        reply.status(200).send(request.user);
    })
    
    app.get("/", (request, reply) => {
        console.log("PUBLIC");
        reply.status(200).send();
    })

    app.listen({
        host: "0.0.0.0",
        port: 3000,
    }).then(() => {
        console.log("Running on http://localhost:3000");
    })
}

setRegister();