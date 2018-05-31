<template> 
    <div>
        <wxc-cell title="默认"
            :has-top-border="true">
          <text @click="showNormalDate" v-if="normalDateText">选择时间</text>
          <text @click="showNormalDate" v-if="normalDateVal">{{normalDate}}</text>
        </wxc-cell>
        <wxc-cell title="开始时间"
            :has-top-border="true" >
          <text @click="showStartDate" v-if="startDateText">请选择</text>
          <text @click="showStartDate" v-if="startDateVal">{{startDate}}</text>
        </wxc-cell>
        <wxc-cell title="结束时间"
            :has-top-border="true" >
          <text @click="showEndDate" v-if="endDateText">请选择</text>
          <text @click="showEndDate" v-if="endDateVal">{{endDate}}</text>
        </wxc-cell>
    </div>
</template>
<script>
import { WxcCell } from 'weex-ui';

const dateTimePicker = weex.requireModule('dateTimePicker');

import Title from '../_mods/title';
export default {
    components: { WxcCell, Title }, 
    data () {
        return {
            normalDateText: true,
            normalDateVal: false,
            normalDate: '',
            startDateText: true,
            startDateVal: false,
            startDate: '',
            endDateText: true,
            endDateVal: false,
            endDate: '',
        }
    },
    methods: {
        showNormalDate (){
            dateTimePicker.open({
                value: this.normalDate,
            },(res) =>{
                if(res.result === 'success'){
                    this.normalDateText = false;
                    this.normalDateVal = true;
                    this.normalDate = res.data;
                }else if(res.result === 'cancel'){
                    this.$notice.toast({
                        message: '取消'
                    });
                }else{
                    this.$notice.toast({
                        message: 'error'
                    });
                }
            });
        },
        showStartDate (){
            dateTimePicker.open({
                value: this.startDate,
                max: this.endDate,
                min: '2018-01-01 00:00',
                title: '请选择开始时间',
                titleColor: '#808080',
                confirmTitle: '确认', 
                confirmTitleColor: '#FF0000', 
                cancelTitle: '取消',
                cancelTitleColor: '#000080',
            },(res) =>{
                if(res.result === 'success'){
                    this.startDateText = false;
                    this.startDateVal = true;
                    this.startDate = res.data;
                }else if(res.result === 'cancel'){
                    this.$notice.toast({
                        message: '取消'
                    });
                }else{
                    this.$notice.toast({
                        message: 'error'
                    });
                }
            });
        },
        showEndDate (){//结束时间
            if(this.startDate === ''){
                this.$notice.toast({
                    message: '请先选择开始时间'
                })
            }else{
                dateTimePicker.open({
                    value: this.endDate,
                    max: '',
                    min: this.startDate,
                    title: '请选择结束时间',
                    titleColor: '#808080',
                    confirmTitle: '确认', 
                    confirmTitleColor: '',
                    cancelTitle: '',
                    cancelTitleColor: '',
                },(res) =>{
                    if(res.result === 'success'){
                        this.endDateText = false;
                        this.endDateVal = true;
                        this.endDate = res.data;
                    }else if(res.result === 'cancel'){
                        this.$notice.toast({
                            message: '取消'
                        });
                    }else{
                        this.$notice.toast({
                            message: 'error'
                        });
                    }
                });
            }
        },
    }
}
</script>

