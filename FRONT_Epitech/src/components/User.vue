<template>
    <div class="container">
        <b-button v-on:click="disconnect" class="btn-disconnect btn btn-secondary">DISCONNECT</b-button>
        <div class="jumbotron text-center" id="graph">
            <h1> Your Working Times</h1>
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
        <div v-if="response.role === 'manager' || response.role === 'admin'" class="jumbotron text-center" id="manager">
                <h1>Your Team Working Times</h1>
                <line-chart :data="this.teamwt"></line-chart>
                <!-- <div v-for="user in allusers" v-bind:key="user.id">
                    <div v-if="response.teamid === user.teamid">
                        <b-button class="tm-button btn btn-primary" v-on:click="manageTeam(user.id)">{{user.username}}</b-button>
                    </div>
                </div> -->
        </div>
        <div v-if="response.role === 'admin'" id="admin">
            <div class="jumbotron text-center">
                <h1>Get Users Working Times</h1>
                <line-chart :data="this.tmpuserwt"></line-chart>
                <div class="flex-row listuser">
                    <div v-for="user in allusers" v-bind:key="user.id">
                        <b-button class="tm-button btn btn-primary" v-on:click="manageUser(user.id)">{{user.username}}</b-button>
                    </div>
                </div>
            </div>
            <div class="jumbotron text-center">
                <h1>Manage Users teams</h1>
                <h3>{{userteam.username}} is a {{userteam.role}} in Team {{userteam.teams}}</h3>
                <b-form-input class="tm-form" type="number" id="input-large" size="lg" v-model="newteam" placeholder="New Team"/>
                <b-button v-on:click="updateTeam" class="tm-button btn btn-primary">UPDATE TEAM</b-button>
                <div class="flex-row listuser">     
                    <div v-for="user in allusers" v-bind:key="user.id">
                        <b-button class="tm-button btn btn-primary" v-on:click="manageTeams(user.id)">{{user.username}}</b-button>
                    </div>
                </div>
            </div>
            <div class="jumbotron text-center">
                <h1>Promote Employee to Manager</h1>
                <div class="flex-row listuser">     
                    <div v-for="user in allusers" v-bind:key="user.id">
                        <div v-if="user.role === 'employee'">
                            <b-button class="tm-button btn btn-primary" v-on:click="promoteUser(user)">{{user.username}}</b-button>
                        </div>
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
                    role: null,
                    teams: null,
                }
            },
            tmpuser: {
                user: {
                    firstname: null,
                    lastname: null,
                    username: null,
                    email: null,
                    password: "timemanager",
                    password_confirmation: "timemanager",
                    role: null,
                    teams: null
                }
            },
            response: {
                id: null,
                firstname: null,
                lastname: null,
                email: null,
                username: null,
                role: null,
                teams: null
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
                    teams: null,
                }
            },
            userteam: [],
            teamwt: {},
            newteam: null,
            allwt: [],
            userswt: {},
            dateswt: [],
            tmpuserwt: {}
        }
    },
    methods: {
            disconnect() {
                localStorage.removeItem('jwt');
                this.$router.push('login');
            },
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
                console.log(this.response);
                this.workingtimes.workingtime.teams = this.response.teams;
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
            addhours(time1, time2) {
                var tmp1 = time1.split(':');
                var tmp2 = time2.split(':');

                console.log(tmp1[0] + " " + tmp2[0]);
                var resH = parseInt(tmp1[0], 10) + parseInt(tmp2[0], 10);
                var resm = parseInt(tmp1[1], 10) + parseInt(tmp2[1], 10);
                if (resm > 59) {
                    resH += 1;
                    resm = resm % 60;
                }
                if (resH < 10) {
                    resH = "0" + resH;
                }
                if (resm < 10) {
                    resm = "0" + resm;
                }
                return (resH + ":" + resm);
            },
            manageTeam() {
                const tmp = {};
                var tmpteams = [];
                var index = 0;
                var isAlreadyDate = false;
                while (index < this.allwt.length) {
                    if (this.allwt[index].teams == this.response.teams) {
                        isAlreadyDate = false;
                        var i = 0;
                        if (tmpteams.length == 0) {
                            tmpteams[i] = {};
                            tmpteams[i].date = this.allwt[index].date;
                            tmpteams[i].total = this.allwt[index].total;
                            isAlreadyDate = true;
                        }
                        while (i < tmpteams.length) {
                            if (tmpteams[i].date == this.allwt[index].date) {
                                tmpteams[i].total = this.addhours(tmpteams[i].total, this.allwt[index].total);
                                isAlreadyDate = true;
                            }
                            i++;
                        }
                        if (isAlreadyDate == false) {
                            tmpteams[i] = {};
                            tmpteams[i].date = this.allwt[index].date;
                            tmpteams[i].total = this.allwt[index].total;
                        }
                    }
                    index++;
                }
                index = 0;
                while (index < tmpteams.length) {
                    tmp[tmpteams[index].date] = tmpteams[index].total;
                    index++;
                }
                this.teamwt = tmp;
            },
            manageTeams(id) {
                axios.get('http://localhost:4000/api/users/' + id)
                    .then(response => {
                        console.log(response);
                        this.userteam = response.data;
                    })
                    .catch(error => {
                        console.log(error)
                    })
            },
            updateTeam(user) {
                this.tmpuser.user.firstname = user.firstname;
                this.tmpuser.user.lastname = user.lastname;
                this.tmpuser.user.username = user.username;
                this.tmpuser.user.email = user.email;
                this.tmpuser.user.role = user.role;
                this.tmpuser.user.teams = this.newteam;
                axios.put('http://localhost:4000/api/users/' + user.id, this.tmpuser)
                    .then(response =>{
                        console.log(response);
                    })
                    .catch(error => {
                        console.log(error)
                    })
            },
            promoteUser(user) {
                this.tmpuser.user.firstname = user.firstname;
                this.tmpuser.user.lastname = user.lastname;
                this.tmpuser.user.username = user.username;
                this.tmpuser.user.email = user.email;
                this.tmpuser.user.role = "manager";
                this.tmpuser.user.teams = user.teams;
                axios.put('http://localhost:4000/api/users/' + user.id, this.tmpuser)
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
                        this.manageTeam();
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
                this.Users.user.teams = this.response.teams;
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

.btn-disconnect {
    position: absolute;
    right: 1%;
    top: 12%;
    font-size: 2rem !important;
    background-color: #505C7C;
    color: #f8f8a9;
    transition: 0.3s ease-out;
    -webkit-box-shadow: -1px 6px 25px -12px rgba(0,0,0,0.75);
-moz-box-shadow: -1px 12px 25px -12px rgba(0,0,0,0.75);
box-shadow: -1px 12px 25px -12px rgba(0,0,0,0.75);
}

h1 {
    color: #505c7C !important;
}

h2, h3, h4, h5 {
    color: #282e3c !important;
}

.tm-form {
    margin-top: 2%;
    margin-left: 40%;
    width: 20%;
}

.tm-button {
  font-size: 2rem !important;
    margin-top: 2%;
    background-color: #505C7C;
    color: #f8f8a9;
    transition: 0.3s ease-out;
    -webkit-box-shadow: -1px 6px 25px -12px rgba(0,0,0,0.75);
-moz-box-shadow: -1px 12px 25px -12px rgba(0,0,0,0.75);
box-shadow: -1px 12px 25px -12px rgba(0,0,0,0.75);
}

.tm-button:hover {
    background-color: #fdff00;
    color: #505C7C;
    transition: 0.3s ease-out;
    cursor: pointer;
    border: none;
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
