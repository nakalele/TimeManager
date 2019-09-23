<template>
    <div class="container">
        <div class="jumbotron" id="display">
            <p>User</p>
            <p>Start {{workingTimes.start}}</p>
            <p>End {{workingTimes.start}}</p>
        </div>

        <div class="jumbotron" id="create">
            <h3>Add a working time !</h3>
            <input v-model="workingTimes.start" placeholder="Begin"/>
            <input v-model="workingTimes.end" placeholder="End"/>
            <b-button v-on:click="createWorkingTime" class="btn btn-primary">Ok</b-button>
        </div>

        <div class="jumbotron" id="edit">
            <h3>Edit this working time !</h3>
            <input placeholder="User id"/>
            <input v-model="workingTimes.start" placeholder="Begin"/>
            <input v-model="workingTimes.end" placeholder="End"/>
            <b-button v-on:click="updateWorkingTime" class="btn btn-primary">Ok</b-button>
        </div>
    </div>
</template>

<script>
    const axios = require('axios');

    export default {
        name: "WorkingTime",
        data() {
            return {
                userId: null,
                workingTimes: {
                    start: null,
                    end: null,
                    userId: this.userId,
                },
                postWorkingTimes: {
                    start: null,
                    end: null,
                    userId: this.userId,
                },
                editWorkingTimes: {
                    start: null,
                    end: null,
                    userId: this.userId,
                },
                deleteId: null,
                responseSuccess: false,
            }
        },
        methods: {
            createWorkingTime() {
                if (!this.userId)
                    return;
                axios
                    .post('http://localhost:4000/api/workingtimes/', this.post_workingTimes)
                    .then(response => {
                        this.responseSuccess = true;
                        this.console.log(response);
                    })
                    .catch(error => {
                        this.responseSuccess = false;
                        this.console.log(error)
                    })
            },
            updateWorkingTime() {
                axios
                    .put('http://localhost:4000/api/workingtimes/', this.edit_workingTimes)
                    .then(response => {
                        this.responseSuccess = true;
                        this.workingTimes = response.data
                    })
                    .catch(error => {
                        this.responseSuccess = false;
                        this.console.log(error)
                    })
            },
            deleteWorkingTime() {
                if (!this.deleteId)
                    return;
                axios
                    .delete("http://localhost:4000/api/workingtimes/" + this.deleteId)
                    .then(response => {
                        this.console.log(response);
                        this.responseSuccess = true;
                    })
                    .catch(error => {
                        this.responseSuccess = false;
                        this.console.log(error);
                    })
            },
        },
    }
</script>