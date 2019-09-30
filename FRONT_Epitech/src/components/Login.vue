<template>
    <div class="container">
        <div class="jumbotron text-center" id="get">
            <h1>Login</h1>
            <b-form-input class="tm-form" id="input-large" size="lg" type="email" v-model="Users.user.email" placeholder="Email"/>
            <b-form-input class="tm-form" id="input-large" size="lg" type="password" v-model="Users.user.password" placeholder="Password"/>
            <b-button v-on:click="login" class="tm-button btn btn-primary">Login</b-button>
            <h4 class="login-information"> In the case you have been promoted to manager or moved in another team you're password was been changed so please try with the password: "timemanager". <br/>For security reason please update your password straigt after.  </h4>
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
        }
    },
    methods: {
            getUser() {
                axios.get('http://localhost:4000/api/my_user', { headers: {'Authorization': 'Bearer ' + localStorage.getItem('jwt')}})
                    .then(response => {
                        console.log(response);
                        this.$router.push('user');
                    })
                    .catch(error => {
                        console.log(error);
                    })
            },
            login() {
                axios.post('http://localhost:4000/api/sign_in', this.Users.user)
                    .then(response => {
                        localStorage.setItem('jwt', response.data.jwt);
                        this.getUser();
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

.login-information {
    color: red !important;
    margin-left: 20%;
    margin-right: 20%;
    margin-top: 2%;
    text-align: center;
    font-size: 1.5rem;
}

</style>