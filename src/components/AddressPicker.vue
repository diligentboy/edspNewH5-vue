<template>
  <van-popup :show="modelValue" @update:show="$emit('update:modelValue', $event)" position="bottom" round :lock-scroll="true">
    <van-area
      :area-list="areaList"
      @confirm="onConfirm"
      @cancel="onCancel"
      :columns-height="200"
      :visible-option-num="5"
      :swipe-duration="1000"
      :option-height="40"
      :touchable="true"
    />
  </van-popup>
</template>

<script>
import { areaList } from '@vant/area-data';

export default {
  name: 'AddressPicker',
  props: {
    modelValue: {
      type: Boolean,
      default: false
    }
  },
  emits: ['close', 'confirm', 'update:modelValue'],
  data() {
    return {
      areaList: areaList
    }
  },
  methods: {
    onConfirm({ selectedOptions }) {
      // 处理 Vant 4 Area 组件的 confirm 事件参数
      let area = '';
      console.log('AddressPicker onConfirm received selectedOptions:', selectedOptions);
      
      if (selectedOptions && Array.isArray(selectedOptions)) {
        area = selectedOptions.map(item => item.text || item.label || item.name || item).join(' ');
      }
      
      console.log('AddressPicker emitting area:', area);
      this.$emit('confirm', area);
      this.$emit('update:modelValue', false);
    },
    onCancel() {
      this.$emit('update:modelValue', false)
    }
  }
}
</script>

<style scoped>
.van-area__header {
  border-bottom: 1px solid #f0f0f0;
  position: relative;
  z-index: 10;
}

.van-area__confirm {
  color: #1989fa;
  font-weight: 500;
}

.van-area__cancel {
  color: #999;
}

/* 确保地址选择器可以正常滚动和拖动 */
.van-area {
  height: 260px;
  touch-action: none;
}

.van-area__columns {
  height: 200px;
  display: flex;
  touch-action: none;
}

.van-area__column {
  flex: 1;
  height: 100%;
  -webkit-overflow-scrolling: touch;
  overflow-y: auto;
  touch-action: pan-y;
  user-select: none;
  -webkit-user-select: none;
  cursor: grab;
  overflow-scrolling: touch;
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.van-area__column::-webkit-scrollbar {
  display: none;
}

.van-area__column:active {
  cursor: grabbing;
}

.van-area__item {
  height: 40px;
  line-height: 40px;
  padding: 0 10px;
  text-align: center;
  transition: background-color 0.2s;
  user-select: none;
  -webkit-user-select: none;
  cursor: pointer;
}

.van-area__item:active {
  background-color: #f5f5f5;
}

/* 为 Safari 浏览器添加特殊处理 */
@supports (-webkit-overflow-scrolling: touch) {
  .van-area__column {
    -webkit-overflow-scrolling: touch;
    overflow-y: auto;
  }
}

/* 确保在所有浏览器中都能正常滚动 */
.van-area__column {
  -webkit-transform: translateZ(0);
  transform: translateZ(0);
  will-change: transform;
}
</style>
