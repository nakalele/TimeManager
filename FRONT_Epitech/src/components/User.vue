<template>
    <div class="container">
        <div class="jumbotron text-center" id="display">
            <h2>Hi {{response.username}}</h2>
            <h3>This is your personal informations. Feel free to change them</h3>
            <h3>firstname {{response.firstname}}</h3>
            <h3>lastname: {{response.lastname}}</h3>
            <h3>email: {{response.email}}</h3>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.firstname" placeholder="Firstname"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.lastname" placeholder="Lastname"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.username" placeholder="Username"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.email" placeholder="Email"/>
            <b-form-input class="tm-form" type="password" id="input-large" size="lg" v-model="Users.user.password" placeholder="Password"/>
            <b-form-input class="tm-form" type="password" id="input-large" size="lg" v-model="Users.user.password_confirmation" placeholder="Password Confirmation"/>
            <b-button v-on:click="updateUser" class="tm-button btn btn-primary">UPDATE</b-button>
        </div>
        <!-- <div class="jumbotron" id="get">
            <h3>Find a user</h3>
            <b-form-input v-model="Users.user.id" placeholder="Id"/>
            <b-button v-on:click="getUser" class="btn btn-primary">Get</b-button>
        </div>
        <div class="jumbotron" id="create">
            <h3>Add a user</h3>
            <b-form-input v-model="Users.user.username" placeholder="Firstname"/>
            <b-form-input v-model="Users.user.username" placeholder="Lastname"/>
            <b-form-input v-model="Users.user.username" placeholder="Username"/>
            <b-form-input v-model="Users.user.email" placeholder="Email"/>
            <b-form-input type="password" v-model="Users.user.password" placeholder="Password"/>
            <b-button v-on:click="createUser" class="btn btn-primary">Create</b-button>
        </div>
        <div class="jumbotron" id="update">
            <h3>Update a user</h3>
            <b-form-input v-model="Users.user.id" placeholder="Id"/>
            <b-form-input v-model="Users.user.username" placeholder="Firstname"/>
            <b-form-input v-model="Users.user.username" placeholder="Lastname"/>
            <b-form-input v-model="Users.user.username" placeholder="Username"/>
            <b-form-input v-model="Users.user.email" placeholder="Email"/>
            <b-form-input type="password" v-model="Users.user.password" placeholder="Password"/>
            <b-button v-on:click="updateUser" class="btn btn-primary">Update</b-button>
        </div> -->
        <div class="jumbotron text-center" id="delete">
            <b-button v-on:click="deleteUser" class=" tm-button btn btn-primary">DELETE YOUR ACCOUNT</b-button>
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
                    firstname: null,
                    lastname: null,
                    username: null,
                    email: null,
                    password: null,
                    password_confirmation: null,
                    role: null
                }
            },
            response: {
                id: null,
                firstname: null,
                lastname: null,
                email: null,
                username: null,
            }
        }
    },
    methods: {
            getUser() {
                axios.get('http://localhost:4000/api/my_user', { headers: {'Authorization': 'Bearer ' + localStorage.getItem('jwt')}})
                    .then(response => {
                        this.response = response.data;
                        console.log(response);
                    })
                    .catch(error => {
                        console.log(error);
                    })
            },
            updateUser() {
                axios
                    .put('http://localhost:4000/api/users/' + this.response.id, this.Users)
                    .then(response => {
                        console.log(response);
                        this.getUser();
                    })
                    .catch(error => {
                        this.console.log(error)
                    })
            },
            deleteUser() {
                axios
                    .delete('http://localhost:4000/api/users/' + this.response.id)
                    .then(response => {
                        localStorage.removeItem('jwt');
                        this.$router.push('login');
                    })
                    .catch(error => {
                        this.console.log(error);
                    })
            },
        },
    beforeMount(){
        this.getUser();
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