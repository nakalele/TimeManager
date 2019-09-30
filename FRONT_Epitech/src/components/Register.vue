<template>
    <div class="container">
        <div class="jumbotron text-center" id="create">
            <h1>Register</h1>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.firstname" placeholder="Firstname"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.lastname" placeholder="Lastname"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.username" placeholder="Username"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.email" placeholder="Email"/>
            <b-form-input class="tm-form" id="input-large" size="lg" type="password" v-model="Users.user.password" placeholder="Password"/>
            <b-form-input class="tm-form" id="input-large" size="lg" type="password" v-model="Users.user.password_confirmation" placeholder="Password Confirmation"/>
            <b-button v-on:click="createUser" class="tm-button btn btn-primary">Register</b-button>
        </div>
    </div>
</template>

<script>

export default {
    name: "User",
    data() {
        return {
            Users: {
                user: {
                    email: null,
                    username: null,
                    firstname: null,
                    lastname: null,
                    role: "employee",
                    password: null,
                    password_confirmation: null,
                    teams: 0
                },
            }
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
            createUser() {
                axios.post('http://localhost:4000/api/sign_up', this.Users)
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

</style>