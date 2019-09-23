<template>
    <div class="container">

        <h1>Working Times</h1>
        <b-table striped hover :items="workingTimes" :fields="fields"></b-table>

        <bar-chart
                id="bar"
                xkey="date"
                :data="workingTimes_table"
                ykeys='[ "start_time", "end_time"]'
                bar-colors='["#FF6384", "#36A2EB"]'
                labels='[ "Values y", "Values z"]'
                grid="true"
                grid-text-weight="bold"
                resize="false">
        </bar-chart>

        <line-chart
                id="line"
                :data="workingTimes_table"
                xkey="date"
                ykeys='[ "start_time", "end_time"]'
                line-colors='["#FF6384", "#36A2EB"]'
                xLabels="Year"
                labels='[ "Values y", "Values z"]'
                grid="true"
                grid-text-weight="bold"
                resize="false">
        </line-chart>
    </div>
</template>

<script>
import {BarChart, LineChart} from "vue-morris";
const axios = require("axios");
const moment = require("moment");

export default {
    name: "WorkingTimes",
    components: {BarChart, LineChart},
    data() {
        return {
            userId: null,
            workingTimes: [],
            success: false,
            fields: [ "id", "userId", "user",  "date", "start_time", "end_time"],
            workingTimes_table: [
                {
                    date: "2019-07-21",
                    start_time: "07:00",
                    end_time: "17:00",
                    hours: moment(this.start_time).diff(moment(this.end_time), "hours"),
                },
                {
                    date: "2019-09-02",
                    start_time: "09:30",
                    end_time: "18:30",
                    hours: moment(this.start_time).diff(moment(this.end_time), "hours"),
                },
                {
                    date: "2019-09-08",
                    start_time: "08:45",
                    end_time: "18:45",
                    hours: moment(this.start_time).diff(moment(this.end_time), "hours"),
                },
                {
                    date: "2019-09-10",
                    start_time: "08:50",
                    end_time: "17:30",
                    hours: moment(this.start_time).diff(moment(this.end_time), "hours"),
                },
            ]
        }
    },
    beforeRouteEnter (to, from, next) {
        next(vm => {
            if (to.params.userId) {
                vm.userId = to.params.userId;
                vm.getWorkingTimes();
            }
            else {
                vm.userId = null;
            }
        })
    },
    methods: {
        getWorkingTimes() {
            if (!this.userId)
                return;
            axios
                .get('http://localhost:4000/api/workingtimes')
                .then(response => {
                    console.log("test");
                    this.success = true;
                    response.data.forEach((index) => {
                        this.workingTimes.add({
                            id: index.id,
                            userId: index.userId,
                            user: index.user.username,
                            date: moment(index.start).format("DD/MM/YYYY"),
                            start_time: index.start,
                            end_time: index.end,
                            hours: moment(index.start).diff(moment(index.end), "hours")
                        });
                    });
                })
                .catch(error => {
                    this.success = false;
                    this.console.log(error)
                })
        }
    },
}
</script>