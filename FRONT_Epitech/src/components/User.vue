<template>
    <div class="container">
        <div class="jumbotron text-center" id="graph">
            <line-chart :data="this.userswt"></line-chart>
        </div>
        <div class="jumbotron text-center" id="display">
            <h1>Hi {{response.username}}</h1>
            <h3>This is your personal informations. Feel free to change them</h3>
            <h2>Role: {{response.role}}</h2>
            <h2>firstname: {{response.firstname}}</h2>
            <h2>lastname: {{response.lastname}}</h2>
            <h2>email: {{response.email}}</h2>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.firstname" placeholder="Firstname"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.lastname" placeholder="Lastname"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.username" placeholder="Username"/>
            <b-form-input class="tm-form" id="input-large" size="lg" v-model="Users.user.email" placeholder="Email"/>
            <b-form-input class="tm-form" type="password" id="input-large" size="lg" v-model="Users.user.password" placeholder="Password"/>
            <b-form-input class="tm-form" type="password" id="input-large" size="lg" v-model="Users.user.password_confirmation" placeholder="Password Confirmation"/>
            <b-button v-on:click="updateUser" class="tm-button btn btn-primary">UPDATE</b-button>
        </div>
        <div class="jumbotron text-center" id="workingtime">
            <h1> Add your Working Time of the day</h1>
            <b-form-input class="tm-form" id="start input-large" size="lg" type="date" v-model="workingtimes.workingtime.date" />
            <label class="time" for="start">Start Time</label>
            <b-form-input v-model="workingtimes.workingtime.start" class="tm-form" id="start input-large" size="lg" type="time"></b-form-input>
            <label class="time" for="end">End Time</label>
            <b-form-input v-model="workingtimes.workingtime.end" class="tm-form" id="end input-large" size="lg" type="time"></b-form-input>
            <b-button v-on:click="saveTime" class="tm-button btn btn-primary">SAVE WORKING TIME</b-button>
        </div>
        <div v-if="response.role === 'admin'" id="admin">
            <div v-if="response.role === 'manager'" class="jumbotron text-center" id="manager">
                <!-- <div v-for="user in allusers">
                    <button v-onclick="manageUser(user.id)">{{user.name}}</button>
                </div> -->
            </div>
            <div class="jumbotron text-center">
                <line-chart :data="this.tmpuserwt"></line-chart>
                <div class="flex-row listuser">
                    <div v-for="user in allusers" v-bind:key="user.id">
                        <b-button class="tm-button btn btn-primary" v-on:click="manageUser(user.id)">{{user.username}}</b-button>
                    </div>
                </div>
            </div>
            <div class="jumbotron text-center">
                <div class="flex-row listuser">     
                    <div v-for="user in allusers" v-bind:key="user.id">
                        <b-button class="tm-button btn btn-primary" v-on:click="promoteUser(user.id)">{{user.username}}</b-button>
                    </div>
                </div>
            </div>
        </div>
        <div class="jumbotron text-center" id="delete">
            <b-button v-on:click="deleteUser" class=" tm-button btn btn-primary">DELETE YOUR ACCOUNT</b-button>
        </div>
    </div>
</template>

<script>
import moment from 'moment';
import Vue from 'vue'
import Chartkick from 'vue-chartkick'
import Chart from 'chart.js'

Vue.use(Chartkick.use(Chart))
export default {
    name: "User",
    components: {
        highcharts: Chart
      },
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
                role: null
            },
            usermanage: {
                id: null,
                firstname: null,
                lastname: null,
            },
            allusers: [],
            workingtimes: {
                workingtime: {
                    start: null,
                    end: null,
                    date: null,
                    total: null,
                    user: null,  
                }
            },
            allwt: [],
            userswt: {},
            dateswt: [],
            tmpuserwt: {}
        }
    },
    methods: {
            getWorkingTimes() {
                axios.get('http://localhost:4000/api/workingtimes/')
                    .then(response => {
                        this.allwt = response.data.data;
                        const tmp = {}
                        console.log(this.allwt.length);
                        var index = 0;
                        while (index < this.allwt.length) {
                            if (this.allwt[index].id == this.response.id) {
                                tmp[this.allwt[index].date] = this.allwt[index].total;
                            }
                            index++;
                        }
                        this.userswt = tmp;
                        console.log(this.userswt);
                    })
                    .catch(error => {
                        console.log(error);
                    })
            },
            saveTime() {
                this.workingtimes.workingtime.total = moment.utc(moment(this.workingtimes.workingtime.end, "HH:mm").diff(moment(this.workingtimes.workingtime.start, "HH:mm"))).format("HH:mm")
                axios.post('http://localhost:4000/api/workingtimes/' + this.workingtimes.workingtime.user, this.workingtimes)
                    .then(response => {
                        console.log(response);
                        this.getWorkingTimes();
                    })
                    .catch(error => {
                        console.log(error);
                    })
            },
            getUserbyID(id) {
                axios.get('http://localhost:4000/api/users' + id)
                    .then(response => {
                        console.log(response);
                    })
                    .catch(error => {
                        console.log(error);
                    })
            },
            manageUser(id) {
                const tmp = {};
                var index = 0;
                while (index < this.allwt.length) {
                    if (this.allwt[index].id == id) {
                        tmp[this.allwt[index].date] = this.allwt[index].total;
                    }
                    index++;
                }
                this.tmpuserwt = tmp;
            },
            promoteUser(id) {
                console.log(id);
                const user = {
                    user: {
                        role: "manager"
                    }
                }
                axios.put('http://localhost:4000/api/users/role/' + id, user)
                    .then(response =>{
                        console.log(response);
                    })
                    .catch(error => {
                        console.log(error)
                    })
            },
            getUsers() {
                axios.get('http://localhost:4000/api/users')
                    .then(response => {
                        console.log(response);
                        this.allusers = response.data.data;
                        console.log(this.allusers[0].username);
                    })
                    .catch(error => {
                        console.log(error);
                    })
            },
            getUser() {
                axios.get('http://localhost:4000/api/my_user', { headers: {'Authorization': 'Bearer ' + localStorage.getItem('jwt')}})
                    .then(response => {
                        this.response = response.data;
                        this.workingtimes.workingtime.user = response.data.id;
                        console.log(response);
                        this.getWorkingTimes();
                        if (response.data.role == "admin" || response.data.role == "manager") {
                            this.getUsers()
                        }
                    })
                    .catch(error => {
                        console.log(error);
                    })
            },
            updateUser() {
                axios.put('http://localhost:4000/api/users/' + this.response.id, this.Users)
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

.time {
    font-size: 15px;
    margin: 1.2% -10%;
    position: absolute;
}

.flex-row {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
}

.listuser {
    margin-top: 5%;
}
</style>
