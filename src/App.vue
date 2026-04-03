<template>
  <div class="app">
    <!-- 管理页面 -->
    <div id="admin" class="page" v-if="currentPage === 'admin'">
      <div class="admin-container">
        <h2 class="admin-title">管理设置</h2>
        <div class="admin-form">
          <div class="form-item">
            <label>额度设置</label>
            <input type="number" v-model="adminData.amount" placeholder="请输入额度" required>
          </div>
          <div class="form-item">
            <label>利率设置</label>
            <input type="number" v-model="adminData.rate" step="0.1" placeholder="请输入利率" required>
          </div>
          <div class="btn-container">
            <button class="primary-button" @click="generateQRCode">确认</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 二维码展示页面 -->
    <div id="qrcode-page" class="page" v-if="currentPage === 'qrcode-page'">
      <div class="qrcode-page-container">
        <h2 class="qrcode-page-title">二维码</h2>
        <div class="qrcode">
          <img :src="qrCodeUrl" alt="借款页面二维码">
        </div>
        <p class="qrcode-hint">长按保存二维码，扫描进入借款页面</p>
        <div class="btn-container">
          <button class="primary-button" @click="showPage('admin')">返回设置</button>
        </div>
      </div>
    </div>

    <!-- 首页 -->
    <div id="home" class="page" v-if="currentPage === 'home'">
      <div class="home-card">
        <div class="header">
          <div class="max-amount">最高可借</div>
          <div class="amount">{{ urlParams.e }}</div>
          <div class="sub-text">额度高 为千万用户提供安全服务</div>
        </div>
        <div class="home-btn-container">
          <button class="primary-button" @click="showPage('basic-info')">立即申请</button>
        </div>
        <div class="agreement">
          <label class="checkbox-label">
            <input type="checkbox" v-model="agreementChecked">
            <span class="checkbox-custom"></span>
            <span class="checkbox-text">我已阅读知晓并同意《个人信息授权与隐私政策》</span>
          </label>
        </div>
        <div class="low-rate">最低年化{{ urlParams.l }}% 到账快</div>
      </div>
      <div class="platform-info">
        <div class="title">专业贷款平台</div>
        <div class="features">
          <div>高效优质/超大金额/安全保障</div>
          <div>随借随还超低利息</div>
        </div>
      </div>
    </div>

    <!-- 基本信息页面 -->
    <div id="basic-info" class="page" v-if="currentPage === 'basic-info'">
      <van-nav-bar
        title="基本信息"
        left-text="返回"
        left-arrow
        @click-left="goBack"
      />


      <div class="progress">
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">必填信息</div>
        </div>
        <div class="line"></div>
        <div class="step">
          <div class="circle"></div>
          <div class="label">补充信息</div>
        </div>
        <div class="line"></div>
        <div class="step">
          <div class="circle"></div>
          <div class="label">完成</div>
        </div>
      </div>
      <div class="form-container">
        <div class="form-item required">
          <label>姓名</label>
          <input type="text" v-model="formData.name" placeholder="请输入姓名" required>
        </div>
        <div class="form-item required">
          <label>电话</label>
          <input type="tel" v-model="formData.phone" placeholder="请输入电话" required>
        </div>
        <div class="form-item required">
          <label>身份证</label>
          <input type="text" v-model="formData.idCard" placeholder="请输入身份证" required>
        </div>
        <div class="id-card-section">
          <div class="id-card-title">上传身份证</div>
          <div class="id-card-upload-area">
            <div class="id-card-box">
              <div class="id-card-icon">📷</div>
              <div class="id-card-text">正面</div>
            </div>
            <div class="id-card-box">
              <div class="id-card-icon">📷</div>
              <div class="id-card-text">反面</div>
            </div>
          </div>
        </div>
        <div class="form-item required">
          <label>住址</label>
          <input type="text" v-model="formData.address" placeholder="请输入住址" required>
        </div>
      </div>
      <div class="btn-container">
        <button class="primary-button" @click="validateBasicInfo()">下一步</button>
      </div>
    </div>

    <!-- 补充信息页面 -->
    <div id="supplement-info" class="page" v-if="currentPage === 'supplement-info'">
      <van-nav-bar
        title="补充信息"
        left-text="返回"
        left-arrow
        @click-left="goBack"
      />


      <div class="progress">
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">必填信息</div>
        </div>
        <div class="line"></div>
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">补充信息</div>
        </div>
        <div class="line"></div>
        <div class="step">
          <div class="circle"></div>
          <div class="label">完成</div>
        </div>
      </div>
      <div class="supplement-form">
        <div class="toggle-section">
          <div class="toggle-header">
            <label>公积金信息:</label>
            <label class="toggle">
              <input type="checkbox" id="fund-toggle" v-model="toggleData.fund">
              <span class="slider"></span>
            </label>
          </div>
          <div id="fund-info" class="toggle-content" v-if="toggleData.fund">
            <div class="form-item">
              <label>缴存金额</label>
              <input type="text" v-model="supplementData.fundAmount" placeholder="请输入缴存金额">
            </div>
            <div class="form-item">
              <label>缴存年限</label>
              <input type="text" v-model="supplementData.fundYears" placeholder="请输入缴存年限">
            </div>
            <div class="form-item">
              <label>缴存单位</label>
              <input type="text" v-model="supplementData.fundCompany" placeholder="请输入缴存单位">
            </div>
          </div>
        </div>

        <div class="toggle-section">
          <div class="toggle-header">
            <label>房屋信息:</label>
            <label class="toggle">
              <input type="checkbox" id="house-toggle" v-model="toggleData.house">
              <span class="slider"></span>
            </label>
          </div>
          <div id="house-info" class="toggle-content" v-if="toggleData.house">
            <div class="form-item">
              <label>房产价值</label>
              <input type="text" v-model="supplementData.houseValue" placeholder="请输入房产价值">
            </div>
            <div class="form-item">
              <label>房产所在地</label>
              <div class="readonly-input" @click="showAreaPicker = true">
                {{ selectedArea || '请选择房产所在地' }}
              </div>
            </div>
            <div class="form-item">
              <label>是否按揭</label>
              <div class="readonly-input" @click="showMortgagePicker = true">
                {{ selectedMortgage || '请选择是否按揭' }}
              </div>
            </div>
          </div>
        </div>

        <div class="toggle-section">
          <div class="toggle-header">
            <label>企业信息:</label>
            <label class="toggle">
              <input type="checkbox" id="company-toggle" v-model="toggleData.company">
              <span class="slider"></span>
            </label>
          </div>
          <div id="company-info" class="toggle-content" v-if="toggleData.company">
            <div class="form-item">
              <label>企业名称</label>
              <input type="text" v-model="supplementData.companyName" placeholder="请输入企业名称">
            </div>
            <div class="form-item">
              <label>职位</label>
              <input type="text" v-model="supplementData.companyPosition" placeholder="请输入职位">
            </div>
          </div>
        </div>

        <div class="toggle-section">
          <div class="toggle-header">
            <label>紧急联系人:</label>
            <label class="toggle">
              <input type="checkbox" id="contact-toggle" v-model="toggleData.contact" disabled>
              <span class="slider"></span>
            </label>
          </div>
          <div id="contact-info" class="toggle-content">
            <div class="form-item required">
              <label>直系亲属姓名</label>
              <input type="text" v-model="supplementData.familyName" placeholder="请输入直系亲属姓名" required>
            </div>
            <div class="form-item required">
              <label>直系亲属电话</label>
              <input type="tel" v-model="supplementData.familyPhone" placeholder="请输入直系亲属电话" required>
            </div>
            <div class="form-item required">
              <label>朋友姓名</label>
              <input type="text" v-model="supplementData.friendName" placeholder="请输入朋友姓名" required>
            </div>
            <div class="form-item required">
              <label>朋友电话</label>
              <input type="tel" v-model="supplementData.friendPhone" placeholder="请输入朋友电话" required>
            </div>
            <div class="form-item required">
              <label>同事姓名</label>
              <input type="text" v-model="supplementData.colleagueName" placeholder="请输入同事姓名" required>
            </div>
            <div class="form-item required">
              <label>同事电话</label>
              <input type="tel" v-model="supplementData.colleaguePhone" placeholder="请输入同事电话" required>
            </div>
          </div>
        </div>
      </div>
      <div class="btn-container">
        <button class="primary-button" @click="validateSupplementInfo()">下一步</button>
      </div>
    </div>

    <!-- 审核中页面 -->
    <div id="review" class="page" v-if="currentPage === 'review'">
      <van-nav-bar
        title="审核中"
        left-text="返回"
        left-arrow
        @click-left="goBack"
      />


      <div class="progress">
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">必填信息</div>
        </div>
        <div class="line"></div>
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">补充信息</div>
        </div>
        <div class="line"></div>
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">完成</div>
        </div>
      </div>
      <div class="review-container">
        <div class="review-animation">
          <svg class="circle-spinner" viewBox="0 0 100 100">
            <circle cx="50" cy="50" r="45" fill="none" stroke="#ff4d4f" stroke-width="7" stroke-dasharray="283" stroke-dashoffset="283" stroke-linecap="round"></circle>
          </svg>
          <div class="review-text">审核中</div>
        </div>
        <div class="review-desc">信息已提交，正在审核中，请注意查看</div>
      </div>
    </div>

    <!-- 额度结果页面 -->
    <div id="result" class="page" v-if="currentPage === 'result'">
      <van-nav-bar
        title="额度结果"
        left-text="返回"
        left-arrow
        @click-left="goBack"
      />


      <div class="progress">
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">必填信息</div>
        </div>
        <div class="line"></div>
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">补充信息</div>
        </div>
        <div class="line"></div>
        <div class="step active">
          <div class="circle checked">✓</div>
          <div class="label">完成</div>
        </div>
      </div>
      <div class="result-container">
        <div class="amount-circle">
          <div id="result-amount" class="amount">{{ urlParams.e }}</div>
        </div>
        <div class="result-status">审核通过</div>
        <button class="withdraw-btn" @click="showPage('my-loan')">立即提现</button>
      </div>
    </div>

    <!-- 我的借款页面 -->
    <div id="my-loan" class="page" v-if="currentPage === 'my-loan'">
      <van-nav-bar
        title="我的借款"
        left-text="返回"
        left-arrow
        @click-left="goBack"
      />


      <div class="header">
      </div>
      <div class="home-card">
        <div class="card-content">
          <div class="max-amount">经审核您可借额度</div>
          <div id="loan-amount" class="card-amount">{{ urlParams.e }}</div>
          <div class="sub-text">额度高 为千万用户提供安全服务</div>
        </div>
        <div class="home-btn-container">
          <button class="primary-button" @click="showPage('loan')">立即申请</button>
        </div>
        <div class="agreement">
          <label class="checkbox-label">
            <input type="checkbox" v-model="loanAgreementChecked">
            <span class="checkbox-custom"></span>
            <span class="checkbox-text">我已阅读知晓并同意《个人信息授权与隐私政策》</span>
          </label>
        </div>
        <div class="low-rate">最低年化{{ urlParams.l }}% 到账快</div>
      </div>
      <div class="platform-info">
        <div class="title">专业贷款平台</div>
        <div class="features">
          <div>高效优质</div>
          <div>超大金额</div>
          <div>安全保障</div>
          <div>随借随还超低利息</div>
        </div>
      </div>
    </div>

    <!-- 借款页面 -->
    <div id="loan" class="page" v-if="currentPage === 'loan'">
      <van-nav-bar
        title="借款"
        left-text="返回"
        left-arrow
        @click-left="goBack"
      />


      <div class="header">
        <div id="loan-max-amount" class="amount">{{ urlParams.e }}</div>
        <div class="sub-text">最高可借额度</div>
      </div>
      <div class="card-container">
        <div class="card">
          <div class="form-item">
            <label>借款金额：</label>
            <input type="number" v-model="loanData.amount" @input="handleAmountInput" class="amount-input" placeholder="请输入借款金额">
          </div>
          <div class="warning-message">
            <p>贷款仅能用于日常消费，请勿将借款用于理财投资或利用借款从事违法犯罪活动!</p>
          </div>

        </div>
        <div class="card loan-details" style="margin-top: 15px;">
          <div class="form-item">
            <label>借多久</label>
            <div class="readonly-input" @click="showMonthPicker = true">
              {{ selectedMonth || '36个月' }}
            </div>
          </div>
          <div class="form-item">
            <label>借款方式</label>
            <div class="readonly-input">等额本息</div>
          </div>
          <div class="form-item">
            <label>利率</label>
            <div class="readonly-input">年化利率{{ urlParams.l }}%</div>
          </div>
          <div class="form-item">
            <label>每月还</label>
            <div class="readonly-input">{{ monthlyPayment }}</div>
          </div>
          <div class="form-item">
            <label>收款账户</label>
            <div class="readonly-input" @click="showPage('bank-account')">
              {{ bankAccount || '请绑定收款账户' }}
            </div>
          </div>
        </div>
        <div class="extract-btn-container">
          <button class="primary-button" @click="extractLoan()">立即提取</button>
        </div>
      </div>
    </div>

    <!-- 收款账户页面 -->
    <div id="bank-account" class="page" v-if="currentPage === 'bank-account'">
      <van-nav-bar
        title="收款账户"
        left-text="返回"
        left-arrow
        @click-left="goBack"
      />


      <div class="form-container" style="margin: 20px;">
        <div class="form-item">
          <label>姓名</label>
          <input type="text" v-model="bankData.name" placeholder="请输入姓名" required>
        </div>
        <div class="form-item">
          <label>卡号</label>
          <input type="text" v-model="bankData.number" placeholder="请输入卡号" required>
        </div>
        <div class="form-item">
          <label>银行</label>
          <input type="text" v-model="bankData.bank" placeholder="请输入银行" required>
        </div>
        <div class="bank-card-section">
          <div class="bank-card-title">请拍照上传银行卡号识别或手动输入银行卡完整卡号</div>
          <div class="bank-card-upload-area">
            <div class="bank-card-box">
              <div class="bank-card-icon">💳</div>
              <div class="bank-card-text">选择银行卡自动录入</div>
            </div>
          </div>
        </div>
      </div>
      <div class="btn-container">
        <button class="primary-button" @click="bindAccount()">立即绑定</button>
      </div>
    </div>

    <!-- 加载动画 -->
    <div id="loading" class="loading" v-if="loading">
      <div class="spinner"></div>
      <div class="loading-text">{{ loadingText }}</div>
    </div>

    <!-- 地址选择器 -->
    <AddressPicker
      v-model="showAreaPicker"
      @confirm="onAreaConfirm"
    />


    <!-- 按揭选择器 -->
    <van-popup v-model:show="showMortgagePicker" position="bottom" round style="z-index: 9999;">
      <van-picker
        title="选择是否按揭"
        :columns="mortgageColumns"
        @confirm="confirmMortgage"
        @cancel="showMortgagePicker = false"
      />
    </van-popup>

    <!-- 月份选择器 -->
    <van-popup v-model:show="showMonthPicker" position="bottom" round style="z-index: 9999;">
      <van-picker
        title="选择借款期限"
        :columns="monthColumns"
        @confirm="confirmMonth"
        @cancel="showMonthPicker = false"
        style="background-color: #fff;"
      />
    </van-popup>
  </div>
</template>

<script>
import AddressPicker from './components/AddressPicker.vue';
import QRCode from 'qrcode';
import { showToast } from 'vant';


export default {
  name: 'App',
  components: {
    AddressPicker
  },
  data() {
    return {
      currentPage: 'home',
      urlParams: {
        e: '50000',
        l: '4.3'
      },
      agreementChecked: true,
      loanAgreementChecked: true,
      formData: {
        name: '',
        phone: '',
        idCard: '',
        address: ''
      },
      toggleData: {
        fund: false,
        house: false,
        company: false,
        contact: true
      },
      supplementData: {
        fundAmount: '',
        fundYears: '',
        fundCompany: '',
        houseValue: '',
        familyName: '',
        familyPhone: '',
        friendName: '',
        friendPhone: '',
        colleagueName: '',
        colleaguePhone: '',
        companyName: '',
        companyPosition: ''
      },
      loanData: {
        amount: '186000'
      },
      bankData: {
        name: '',
        number: '',
        bank: ''
      },
      bankAccount: '',
      selectedArea: '',
      selectedMortgage: '是',
      showAreaPicker: false,
      showMortgagePicker: false,
      showMonthPicker: false,
      selectedMonth: '36个月',
      selectedMonthValue: 36,
      months: [12, 24, 36, 48, 60],
      monthColumns: [12, 24, 36, 48, 60].map(month => ({ text: `${month}个月`, value: `${month}个月` })),
      mortgageColumns: [
        { text: '是', value: '是' },
        { text: '否', value: '否' }
      ],
      loading: false,
      loadingText: '处理中...',
      monthlyPayment: '0.00',
      adminData: {
        amount: '50000',
        rate: '4.3'
      },
      qrCodeUrl: ''
    };
  },
  mounted() {
    // 检查是否是管理页面
    const queryString = window.location.search;
    const urlParamsObj = new URLSearchParams(queryString);
    if (urlParamsObj.get('admin') === 'true') {
      this.currentPage = 'admin';
    } else {
      this.getUrlParams();
      this.updateMonthlyPayment();
    }
  },
  methods: {
    getUrlParams() {
      const queryString = window.location.search;
      const urlParamsObj = new URLSearchParams(queryString);
      
      this.urlParams.e = urlParamsObj.get('e') || '50000';
      this.urlParams.l = urlParamsObj.get('l') || '4.3';
      
      if (!queryString) {
        const newUrl = `${window.location.origin}${window.location.pathname}?e=${this.urlParams.e}&l=${this.urlParams.l}`;
        window.history.replaceState({}, '', newUrl);
      }
      
      // 设置默认借款金额为最高可借额度
      this.loanData.amount = this.urlParams.e;
    },
    handleAmountInput() {
      const amount = parseFloat(this.loanData.amount) || 0;
      const maxAmount = parseFloat(this.urlParams.e) || 0;
      
      if (amount > maxAmount) {
        // 超过最高可借额度，设置为最高可借额度
        this.loanData.amount = maxAmount.toString();
        // 使用Toast显示提示信息
        showToast({
          message: `最高可借${maxAmount}元`,
          duration: 2000
        });
      }
      
      // 实时更新每月还款金额
      this.updateMonthlyPayment();
    },
    showPage(pageId) {
      this.currentPage = pageId;
    },
    goBack() {
      if (this.currentPage === 'basic-info') {
        this.showPage('home');
      } else if (this.currentPage === 'supplement-info') {
        this.showPage('basic-info');
      } else if (this.currentPage === 'result') {
        this.showPage('supplement-info');
      } else if (this.currentPage === 'bank-account') {
        this.showPage('loan');
      } else if (this.currentPage === 'loan') {
        this.showPage('my-loan');
      } else if (this.currentPage === 'my-loan') {
        this.showPage('result');
      } else if (this.currentPage === 'review') {
        this.showPage('supplement-info');
      }
    },
    validateBasicInfo() {
      if (!this.formData.name) {
        alert('请输入姓名');
        return;
      }
      if (!/^1[3-9]\d{9}$/.test(this.formData.phone)) {
        alert('请输入正确的手机号');
        return;
      }
      if (!/(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(this.formData.idCard)) {
        alert('请输入正确的身份证号');
        return;
      }
      if (!this.formData.address) {
        alert('请输入住址');
        return;
      }
      this.showPage('supplement-info');
    },
    validateSupplementInfo() {
      if (!this.supplementData.familyName) {
        alert('请输入直系亲属姓名');
        return;
      }
      if (!/^1[3-9]\d{9}$/.test(this.supplementData.familyPhone)) {
        alert('请输入正确的直系亲属手机号');
        return;
      }
      if (!this.supplementData.friendName) {
        alert('请输入朋友姓名');
        return;
      }
      if (!/^1[3-9]\d{9}$/.test(this.supplementData.friendPhone)) {
        alert('请输入正确的朋友手机号');
        return;
      }
      if (!this.supplementData.colleagueName) {
        alert('请输入同事姓名');
        return;
      }
      if (!/^1[3-9]\d{9}$/.test(this.supplementData.colleaguePhone)) {
        alert('请输入正确的同事手机号');
        return;
      }
      this.showPage('review');
      setTimeout(() => {
        this.showPage('result');
      }, 30000);
    },

    confirmMortgage(value) {
      this.selectedMortgage = value.selectedValues[0];
      this.showMortgagePicker = false;
    },
    onAreaConfirm(area) {
      console.log('App onAreaConfirm received:', area);
      // 确保 area 是字符串类型
      if (typeof area === 'string') {
        console.log('Setting selectedArea to:', area);
        this.selectedArea = area;
      } else if (area && typeof area === 'object') {
        // 处理可能的对象结构
        console.log('Received area object:', area);
      }
      this.showAreaPicker = false;
    },
    confirmMonth(value) {
      this.selectedMonth = value.selectedValues[0];
      this.selectedMonthValue = parseInt(value.selectedValues[0].replace('个月', ''));
      this.showMonthPicker = false;
      this.updateMonthlyPayment();
    },
    updateMonthlyPayment() {
      const principal = parseFloat(this.loanData.amount) || 0;
      const annualRate = parseFloat(this.urlParams.l) || 8.52;
      const months = this.selectedMonthValue || 36;
      
      if (principal > 0) {
        const monthlyRate = annualRate / 100 / 12;
        const payment = principal * monthlyRate * Math.pow(1 + monthlyRate, months) / (Math.pow(1 + monthlyRate, months) - 1);
        this.monthlyPayment = payment.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
      } else {
        this.monthlyPayment = '0.00';
      }
    },
    extractLoan() {
      this.loading = true;
      this.loadingText = '账号风险检测中...';
      setTimeout(() => {
        this.loading = false;
        alert('抱歉，您暂时无法提款，原因可能是您存在如下情况:\n1、名下贷款或信用卡逾期情况;\n2、近期频繁申请，大数据评分较低情况;\n3、可能存在贷款资金用于股市楼市、投资等行为;\n4、名下银行账户有存在风险情况;\n5、存在其他方面原因:如需了解详情，请咨询当地客户经理;');
      }, 3000);
    },
    bindAccount() {
      if (!this.bankData.name) {
        alert('请输入姓名');
        return;
      }
      if (!this.bankData.number) {
        alert('请输入卡号');
        return;
      }
      if (!this.bankData.bank) {
        alert('请输入银行');
        return;
      }
      this.bankAccount = this.bankData.number;
      this.showPage('loan');
    },
    generateQRCode() {
      if (!this.adminData.amount) {
        alert('请输入额度');
        return;
      }
      if (!this.adminData.rate) {
        alert('请输入利率');
        return;
      }
      
      // 生成带参数的 URL
      const baseUrl = window.location.origin + window.location.pathname;
      const params = `?e=${this.adminData.amount}&l=${this.adminData.rate}`;
      const loanUrl = baseUrl + params;
      
      // 生成二维码
      QRCode.toDataURL(loanUrl, { width: 256 }, (err, url) => {
        if (err) {
          console.error(err);
          alert('生成二维码失败');
        } else {
          this.qrCodeUrl = url;
          // 跳转到二维码展示页面
          this.showPage('qrcode-page');
        }
      });
    }
  }
};
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background-color: #f5f5f5;
  color: #333;
}

.page {
  width: 100%;
  min-height: 100vh;
  padding: 0;
  background-color: #f5f5f5;
}

/* 我的借款页面样式 */
#my-loan {
  background-color: #f5f5f5;
  min-height: 100vh;
  padding: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

#my-loan .van-nav-bar {
  background-color: #fff;
  color: #000;
  width: 100%;
  position: relative;
  z-index: 10;
  border-bottom: 1px solid #f0f0f0;
  box-shadow: none;
}

#my-loan .van-nav-bar__title {
  color: #000;
}

#my-loan .van-nav-bar__text {
  color: #000;
}

#my-loan .van-nav-bar__arrow {
  color: #000;
}

#my-loan .header {
  background-color: #ff4d4f;
  width: 100%;
  height: 150px;
  text-align: center;
  margin-bottom: -80px;
}

#my-loan .home-card {
  background-color: #fff;
  width: 90%;
  max-width: 500px;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
  z-index: 1;
  margin-top: 0;
}

#my-loan .card-content {
  text-align: center;
  margin-bottom: 15px;
  width: 100%;
}

#my-loan .card-content .max-amount {
  color: #666;
  font-size: 14px;
  margin-bottom: 8px;
}

#my-loan .card-amount {
  color: #000;
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 8px;
}

#my-loan .card-content .sub-text {
  color: #ff4d4f;
  font-size: 12px;
  margin-bottom: 8px;
}

#my-loan .home-btn-container {
  width: 100%;
  margin-bottom: 15px;
}

#my-loan .home-btn-container .primary-button {
  background-color: #1890ff;
  height: 44px;
  border-radius: 22px;
}

#my-loan .agreement {
  margin-bottom: 10px;
  align-self: flex-start;
  font-size: 12px;
}

#my-loan .low-rate {
  color: #666;
  font-size: 12px;
  margin-top: 0;
}

#my-loan .platform-info {
  background-color: #ff4d4f;
  color: #fff;
  padding: 20px;
  border-radius: 10px;
  width: 90%;
  max-width: 500px;
  margin-top: 0;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

#my-loan .platform-info .title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 10px;
}

#my-loan .platform-info .features {
  font-size: 14px;
  line-height: 1.5;
}

/* 借款页面样式 */
#loan {
  background-color: #f5f5f5;
  min-height: 100vh;
  padding: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

#loan .van-nav-bar {
  background-color: #fff;
  color: #000;
  width: 100%;
  position: relative;
  z-index: 10;
  border-bottom: 1px solid #f0f0f0;
  box-shadow: none;
}

#loan .van-nav-bar__title {
  color: #000;
}

#loan .van-nav-bar__text {
  color: #000;
}

#loan .van-nav-bar__arrow {
  color: #000;
}

#loan .header {
  background-color: #ff4d4f;
  width: 100%;
  height: 150px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  margin-bottom: -75px;
}

#loan .header .amount {
  font-size: 48px;
  font-weight: bold;
  margin-bottom: 8px;
  color: #fff;
}

#loan .header .sub-text {
  font-size: 14px;
  color: #fff;
  opacity: 0.9;
}

#loan .card-container {
  width: 90%;
  max-width: 500px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0;
  z-index: 1;
  position: relative;
  margin-top: 0;
}

#loan .card {
  background-color: #fff;
  width: 100%;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-top: 45px;
}

#loan .card.loan-details {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 0;
}

#loan .card.loan-details .form-item {
  border-bottom: none;
  border-radius: 0;
  padding: 15px 20px;
  margin-bottom: 0;
  box-shadow: none;
  position: relative;
}

#loan .card.loan-details .form-item:not(:last-child)::after {
  content: '';
  position: absolute;
  left: 20px;
  right: 20px;
  bottom: 0;
  height: 1px;
  background-color: #f0f0f0;
}

#loan .card.loan-details .form-item:last-child {
  border-bottom: none;
  margin-bottom: 0;
}



#loan .form-item {
  display: flex;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #f0f0f0;
}

#loan .form-item:last-child {
  border-bottom: 1px solid #f0f0f0;
}

#loan .form-item label {
  flex: 0 0 80px;
  font-size: 16px;
  color: #333;
}

#loan .amount-display {
  flex: 1;
  font-size: 18px;
  color: #000;
  font-weight: 500;
}

#loan .amount-input {
  flex: 1;
  height: 40px;
  padding: 0 15px;
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  font-size: 16px;
  color: #000;
  font-weight: 500;
}



#loan .warning-message {
  padding: 15px 0;
  margin-top: 10px;
}

#loan .warning-message p {
  color: #ff4d4f;
  font-size: 14px;
  line-height: 1.4;
  word-wrap: break-word;
  white-space: normal;
  margin: 0;
  padding-right: 10px;
}

#loan .card-bottom .form-item {
  padding: 12px 0;
}

#loan .card-bottom .form-item label {
  flex: 0 0 80px;
}

#loan .card-bottom .readonly-input {
  flex: 1;
  height: 36px;
  padding: 0 10px;
  border: none;
  font-size: 16px;
  background-color: transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

#loan .card-bottom .readonly-input::after {
  content: "▼";
  font-size: 12px;
  color: #999;
}

#loan .card-bottom .readonly-input:hover {
  background-color: #f9f9f9;
}

#loan .extract-btn-container {
  width: 100%;
  margin-top: 20px;
  margin-bottom: 30px;
}

#loan .extract-btn-container .primary-button {
  background-color: #1890ff;
  height: 56px;
  border-radius: 28px;
  font-size: 18px;
  font-weight: bold;
}

.hidden {
  display: none !important;
}

/* 首页样式 */
#home {
  background: linear-gradient(to bottom, #ff4d4f 40%, #f5f5f5 40%);
  min-height: 100vh;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.home-card {
  background-color: #fff;
  width: 100%;
  max-width: 500px;
  border-radius: 10px;
  padding: 40px 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  margin-top: 40px;
  margin-bottom: 20px;
}

.header {
  text-align: center;
  margin-bottom: 30px;
}

.max-amount {
  font-size: 18px;
  margin-bottom: 10px;
  color: #333;
}

.amount {
  font-size: 48px;
  font-weight: bold;
  margin-bottom: 10px;
  color: #333;
}

.sub-text {
  font-size: 14px;
  color: #ff4d4f;
  margin-bottom: 30px;
}

.home-btn-container {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.apply-btn {
  width: 100%;
  height: 50px;
  background-color: #1890ff;
  color: #fff;
  border: none;
  border-radius: 25px;
  font-size: 18px;
  font-weight: bold;
  cursor: pointer;
}

.apply-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.agreement {
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 15px 0;
  font-size: 14px;
}

.agreement input {
  margin-right: 8px;
}

.low-rate {
  text-align: center;
  font-size: 14px;
  color: #666;
  margin-top: 10px;
}

.platform-info {
  background-color: #ff4d4f;
  color: #fff;
  padding: 20px;
  border-radius: 10px;
  width: 100%;
  max-width: 500px;
  margin-top: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.platform-info .title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 10px;
}

.platform-info .features {
  font-size: 14px;
  line-height: 1.5;
}

/* 基本信息页面样式 */
.header-bar {
  display: flex;
  align-items: center;
  padding: 15px 20px;
  background-color: #fff;
  margin-bottom: 10px;
}

.back-btn {
  font-size: 24px;
  margin-right: 20px;
  cursor: pointer;
}

.page-title {
  font-size: 18px;
  font-weight: bold;
}

.progress {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 15px 20px;
  background-color: #fff;
  margin-bottom: 10px;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.circle {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background-color: #fff;
  border: 2px solid #1890ff;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 5px;
}

.circle.checked {
  background-color: #1890ff;
  color: #fff;
}

.line {
  flex: 1;
  height: 2px;
  background-color: #e8e8e8;
}

.progress .line {
  flex: 1;
  height: 2px;
  background-color: #e8e8e8;
  margin: 0 10px;
}

.step.active ~ .line {
  background-color: #1890ff;
}

.label {
  font-size: 12px;
  margin-top: 5px;
}

.step.active .label {
  color: #1890ff;
}

.form-container {
  margin: 10px 0;
}

.form-item {
  background-color: #fff;
  display: flex;
  align-items: center;
  padding: 0 20px;
  height: 60px;
  border-radius: 8px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.form-item.upload-section {
  flex-direction: column;
  align-items: flex-start;
  height: auto;
  padding: 20px;
  margin-bottom: 15px;
}

.form-item label {
  font-size: 14px;
  flex: 0 0 100px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.form-item.required label {
  position: relative;
  padding-left: 12px;
}

.form-item.required label::before {
  content: '*';
  color: #ff4d4f;
  position: absolute;
  left: 0;
  top: 0;
}

.form-item input {
  flex: 1;
  height: 40px;
  padding: 0 15px;
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  font-size: 14px;
}

.readonly-input {
  flex: 1;
  height: 40px;
  padding: 0 15px;
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  font-size: 14px;
  background-color: #f9f9f9;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
  transition: all 0.2s ease;
}

.readonly-input:hover {
  background-color: #f0f0f0;
  border-color: #1890ff;
}

.readonly-input:active {
  background-color: #e8e8e8;
}

/* 首页协议标签 */
.agreement label::before {
  display: none;
}

/* 补充信息展开部分样式 */
.toggle-content {
  background-color: #fff;
  border-radius: 8px;
  margin-top: 10px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.toggle-content .form-item {
  display: flex;
  align-items: center;
  padding: 0 20px;
  height: 60px;
  position: relative;
  border: none;
  background: none;
  box-shadow: none;
  margin: 0;
}

.toggle-content .form-item::after {
  content: '';
  position: absolute;
  left: 20px;
  right: 20px;
  bottom: 0;
  height: 1px;
  background-color: #f0f0f0;
}

.toggle-content .form-item:last-child::after {
  display: none;
}

.form-item.upload-section {
  flex-direction: column;
  align-items: flex-start;
  height: auto;
  padding: 20px;
}

.form-item.upload-section label {
  margin-bottom: 5px;
}

.id-card-section {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.id-card-title {
  font-size: 14px;
  color: #333;
  margin-bottom: 10px;
  font-weight: 500;
}

.id-card-upload-area {
  display: flex;
  justify-content: space-between;
  width: 100%;
}

.id-card-box {
  width: 48%;
  height: 100px;
  border: 1px dashed #ff4d4f;
  border-radius: 4px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  position: relative;
}

.id-card-box::before {
  content: '';
  position: absolute;
  top: 8px;
  left: 8px;
  right: 8px;
  bottom: 8px;
  border: 1px dashed #ff4d4f;
  border-radius: 4px;
}

.id-card-icon {
  font-size: 28px;
  margin-bottom: 8px;
}

.id-card-text {
  font-size: 14px;
  color: #666;
}

.bank-card-section {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.bank-card-title {
  font-size: 14px;
  color: #333;
  margin-bottom: 10px;
  font-weight: 500;
  line-height: 1.4;
}

.bank-card-upload-area {
  width: 100%;
}

.bank-card-box {
  width: 100%;
  height: 100px;
  border: 1px dashed #ff4d4f;
  border-radius: 4px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  position: relative;
}

.bank-card-box::before {
  content: '';
  position: absolute;
  top: 8px;
  left: 8px;
  right: 8px;
  bottom: 8px;
  border: 1px dashed #ff4d4f;
  border-radius: 4px;
}

.bank-card-icon {
  font-size: 28px;
  margin-bottom: 8px;
}

.bank-card-text {
  font-size: 14px;
  color: #666;
}

.id-card-upload {
  display: flex;
  justify-content: space-between;
  width: 100%;
}

.card-upload {
  width: 100%;
}

.upload-item {
  width: 48%;
  height: 100px;
  border: 1px dashed #ff4d4f;
  border-radius: 4px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  position: relative;
}

.card-upload .upload-item {
  width: 100%;
}

.upload-item::before {
  content: '';
  position: absolute;
  top: 8px;
  left: 8px;
  right: 8px;
  bottom: 8px;
  border: 1px dashed #ff4d4f;
  border-radius: 4px;
}

.upload-item .icon {
  font-size: 28px;
  margin-bottom: 8px;
}

.upload-item .text {
  font-size: 14px;
  color: #666;
}

.btn-container {
  padding: 20px;
  padding-bottom: 40px;
}

.next-btn, .confirm-btn, .primary-button {
  width: 100%;
  height: 50px;
  background-color: #1890ff;
  color: #fff;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}

/* 补充信息页面样式 */
.supplement-form {
  margin: 10px 0;
  padding-bottom: 20px;
}

.toggle-section {
  margin-bottom: 15px;
}

.toggle-header {
  background-color: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  height: 50px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.toggle-content {
  background-color: #fff;
  border-radius: 8px;
  padding: 10px 0px;
  margin-top: 0px;
  box-shadow: none;
  border-bottom: 1px solid #f0f0f0;;
}

.form-row {
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.form-row:last-child {
  border-bottom: none;
}

.form-row label {
  font-size: 14px;
  flex: 0 0 100px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.form-row.required label {
  position: relative;
  padding-left: 12px;
}

.form-row.required label::before {
  content: '*';
  color: #ff4d4f;
  position: absolute;
  left: 0;
  top: 0;
}

.form-row input,
.form-row select,
.form-row .select-btn {
  flex: 1;
  height: 30px;
  padding: 0 10px;
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  font-size: 14px;
  background-color: #fff;
}

.form-row .select-btn {
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
}

.form-row .select-btn::after {
  content: '▼';
  font-size: 12px;
  color: #999;
}

/* 选择器样式 */
.picker {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  background-color: #fff;
  border-top-left-radius: 10px;
  border-top-right-radius: 10px;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
  z-index: 99999;
  transform: translateY(0);
  transition: transform 0.3s ease;
}

.picker.hidden {
  transform: translateY(100%);
}

.picker-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border-bottom: 1px solid #f0f0f0;
  background-color: #f9f9f9;
}

.cancel-btn {
  color: #999;
  cursor: pointer;
  font-size: 16px;
}

.picker-confirm-btn {
  color: #1890ff;
  cursor: pointer;
  font-weight: bold;
  font-size: 16px;
}

.picker-content {
  display: flex;
  height: 220px;
  overflow: hidden;
  position: relative;
  background-color: #fff;
}

.picker-column {
  flex: 1;
  position: relative;
  overflow: hidden;
}

.picker-column.full-width {
  flex: 1;
}

.column-title {
  padding: 10px;
  font-size: 14px;
  font-weight: bold;
  background-color: #f9f9f9;
  text-align: center;
  color: #666;
  border-bottom: 1px solid #f0f0f0;
}

.column-items {
  height: calc(100% - 40px);
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  scroll-behavior: smooth;
  padding: 60px 0;
  scroll-snap-type: y mandatory;
}

.item {
  padding: 15px 10px;
  text-align: center;
  font-size: 16px;
  transition: all 0.2s ease;
  color: #999;
  opacity: 0.6;
  scroll-snap-align: center;
}

.item.active {
  color: #1890ff;
  font-weight: bold;
  font-size: 18px;
  opacity: 1;
  transform: scale(1.05);
}

/* 中间选择线 */
.picker-content::before,
.picker-content::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  height: 1px;
  background-color: #e8e8e8;
  z-index: 10;
}

.picker-content::before {
  top: 90px;
}

.picker-content::after {
  bottom: 90px;
}

/* 选中区域背景 */
.picker-content .selected-area {
  position: absolute;
  top: 90px;
  bottom: 90px;
  left: 0;
  right: 0;
  background: linear-gradient(to bottom, rgba(255,255,255,0.8), rgba(255,255,255,0.2) 50%, rgba(255,255,255,0.8));
  z-index: 5;
}

/* 优化滚动条样式 */
.column-items::-webkit-scrollbar {
  display: none;
}

.column-items {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.toggle {
  position: relative;
  display: inline-block;
  width: 40px;
  height: 20px;
}

.toggle input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .4s;
  border-radius: 20px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 14px;
  width: 14px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #1890ff;
}

input:checked + .slider:before {
  transform: translateX(20px);
}

/* 额度结果页面样式 */
.result-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-top: 60px;
}

.amount-circle {
  width: 200px;
  height: 200px;
  border: 8px solid #ff4d4f;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 30px;
}

.amount-circle .amount {
  font-size: 36px;
  font-weight: bold;
  color: #ff4d4f;
}

.result-status {
  font-size: 18px;
  margin-bottom: 30px;
}

.withdraw-btn {
  width: 80%;
  height: 50px;
  background-color: #1890ff;
  color: #fff;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}

/* 审核中页面样式 */
.review-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-top: 60px;
}

.review-animation {
  position: relative;
  width: 150px;
  height: 150px;
  margin-bottom: 30px;
}

.circle-spinner {
  width: 100%;
  height: 100%;
  transform: rotate(-90deg);
}

.circle-spinner circle {
  animation: drawCircle 30s ease-in-out forwards;
}

@keyframes drawCircle {
  0% {
    stroke-dashoffset: 283;
  }
  /* 第一阶段：5秒跑完1/3（约94.3）*/
  16.67% {
    stroke-dashoffset: 188.7;
    animation-timing-function: ease-out;
  }
  /* 第二阶段：15秒跑完1/3（约94.3）*/
  66.67% {
    stroke-dashoffset: 94.3;
    animation-timing-function: ease-in;
  }
  /* 第三阶段：10秒跑完1/3（约94.3）*/
  100% {
    stroke-dashoffset: 0;
  }
}

.review-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.review-desc {
  text-align: center;
  font-size: 14px;
  color: #666;
  padding: 0 20px;
}

/* 加载动画样式 */
.loading {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 5px solid #f3f3f3;
  border-top: 5px solid #1890ff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  color: #fff;
  font-size: 16px;
}

/* 修复选择器滑动卡顿+选中错位 */
.picker-content {
  height: 220px;
  position: relative;
  overflow: hidden;
  -webkit-user-select: none;
  user-select: none;
}

.column-items {
  height: 100%;
  overflow-y: scroll;
  -webkit-overflow-scrolling: touch;
  scroll-behavior: smooth;
  padding: 70px 0;
  scroll-snap-type: y mandatory;
}

.item {
  padding: 15px 10px;
  text-align: center;
  font-size: 16px;
  cursor: pointer;
  scroll-snap-align: center;
  transition: all 0.1s ease;
}

.item.active {
  color: #1890ff;
  font-weight: bold;
  font-size: 18px;
}

/* 修复按揭选择器布局 */
.picker-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.picker-actions {
  display: flex;
  gap: 20px;
}

/* 管理页面样式 */
#admin {
  background-color: #f5f5f5;
  min-height: 100vh;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.admin-container {
  width: 100%;
  max-width: 500px;
  background-color: #fff;
  border-radius: 10px;
  padding: 30px 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  margin-top: 40px;
}

.admin-title {
  text-align: center;
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 30px;
  color: #333;
}

.admin-form {
  margin-bottom: 30px;
}

/* 二维码展示页面样式 */
#qrcode-page {
  background-color: #f5f5f5;
  min-height: 100vh;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.qrcode-page-container {
  width: 100%;
  max-width: 500px;
  background-color: #fff;
  border-radius: 10px;
  padding: 40px 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  margin-top: 40px;
  text-align: center;
}

.qrcode-page-title {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 30px;
  color: #333;
}

.qrcode {
  display: flex;
  justify-content: center;
  margin-bottom: 30px;
}

.qrcode img {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  padding: 20px;
  background-color: #fff;
  width: 256px;
  height: 256px;
}

.qrcode-hint {
  font-size: 16px;
  color: #666;
  margin-bottom: 30px;
}

.qrcode-page-container .btn-container {
  margin-top: 20px;
}
</style>