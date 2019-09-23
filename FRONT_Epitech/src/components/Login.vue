<template>
    <div class="container">
        <div class="jumbotron text-center" id="get">
            <h1>Login</h1>
            <b-form-input class="tm-form" id="input-large" size="lg" type="email" v-model="Users.user.email" placeholder="Email"/>
            <b-form-input class="tm-form" type="password" v-model="Users.user.password" placeholder="Password"/>
            <b-button v-on:click="getUser" class="tm-button btn btn-primary">Login</b-button>
        </div>
    </div>
</template>

<script>

export default {
    name: "Login",
    data() {
        return {
            Users: {
                user: {
                    email: null,
                    password: null,
                },
            },
            response: {
                    jwt: null,
            }
        }
    },
    methods: {
            getUser() {
                axios.post('http://localhost:4000/api/sign_in', this.Users, { headers: {'Accept': 'application/json', 'Content-Type': 'text/plain'}})
                    .then(response => {
                        console.log(response);
                        localStorage.setItem('jwt', response.data.data.jwt);
                        this.response.jwt = response.data.data.jwt;
                    })
                    .catch(error => {
                        console.log(error)
                    })
            },
        },
}
</script>

<style>

.tm-form {
    margin-top: 2%;
    margin-left: 40%;
    width: 20%;
}

.tm-button {
    margin-top: 2%;
}

</style>