<template>
  <div class="app-container">
    <!-- 搜索区域 -->
    <div class="search-container">
      <el-input 
        v-model="username" 
        placeholder="输入GitHub用户名" 
        class="username-input"
        clearable
      />
      <el-button 
        type="primary" 
        @click="fetchRepos" 
        class="search-btn"
        :loading="loading"
      >
        {{ loading ? '查询中...' : '查询仓库' }}
      </el-button>
    </div>

    <!-- 仓库列表 -->
    <div class="repos-container">
      <!-- 桌面端表格 -->
      <el-table 
        :data="repos" 
        class="desktop-table"
        v-loading="loading"
        :empty-text="username ? '未找到仓库' : '请输入用户名查询仓库'"
      >
        <el-table-column prop="name" label="仓库名" min-width="120" />
        <el-table-column label="仓库地址" min-width="200">
          <template #default="scope">
            <a :href="scope.row.html_url" target="_blank" class="repo-link">
              {{ scope.row.full_name }}
            </a>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" min-width="250" show-overflow-tooltip />
        <el-table-column prop="stargazers_count" label="Stars" width="80" align="center" />
        <el-table-column prop="forks_count" label="Forks" width="80" align="center" />
        <el-table-column prop="updated_at" label="更新时间" min-width="150" />
      </el-table>

      <!-- 移动端卡片列表 -->
      <div class="mobile-cards">
        <div 
          v-for="repo in repos" 
          :key="repo.id" 
          class="repo-card"
          v-loading="loading"
        >
          <div class="repo-header">
            <h3 class="repo-name">{{ repo.name }}</h3>
            <div class="repo-stats">
              <span class="stat-item">
                <i class="el-icon-star-on"></i>
                {{ repo.stargazers_count }}
              </span>
              <span class="stat-item">
                <i class="el-icon-fork"></i>
                {{ repo.forks_count }}
              </span>
            </div>
          </div>
          
          <p class="repo-description" v-if="repo.description">
            {{ repo.description }}
          </p>
          
          <div class="repo-meta">
            <a :href="repo.html_url" target="_blank" class="repo-link">
              {{ repo.full_name }}
            </a>
            <span class="update-time">
              更新于 {{ formatDate(repo.updated_at) }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-if="!loading && repos.length === 0 && username" class="empty-state">
      <el-empty description="未找到相关仓库" />
    </div>
  </div>
</template>

<script setup>
import { ref, onActivated, onDeactivated } from 'vue'
import { getGithubRepos } from '@/api/system/github'
import { ElMessage } from 'element-plus'

// 定义组件名称，用于keep-alive缓存
defineOptions({
  name: 'Github'
})

const username = ref('')
const repos = ref([])
const loading = ref(false)

// 保存页面状态
const pageState = {
  username: '',
  repos: [],
  scrollTop: 0
}

function fetchRepos() {
  if (!username.value) {
    ElMessage.warning('请输入GitHub用户名')
    return
  }
  
  loading.value = true
  getGithubRepos(username.value).then(res => {
    repos.value = res
    // 保存状态
    pageState.username = username.value
    pageState.repos = res
    if (res.length === 0) {
      ElMessage.info('未找到相关仓库')
    }
  }).catch(error => {
    ElMessage.error('查询失败，请检查用户名是否正确')
    console.error('GitHub API error:', error)
  }).finally(() => {
    loading.value = false
  })
}

function formatDate(dateString) {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN')
}

// 页面激活时恢复状态
onActivated(() => {
  // 恢复用户名和仓库数据
  if (pageState.username) {
    username.value = pageState.username
  }
  if (pageState.repos.length > 0) {
    repos.value = pageState.repos
  }
  
  // 恢复滚动位置
  setTimeout(() => {
    const container = document.querySelector('.app-container')
    if (container && pageState.scrollTop > 0) {
      container.scrollTop = pageState.scrollTop
    }
  }, 100)
})

// 页面失活时保存状态
onDeactivated(() => {
  // 保存当前状态
  pageState.username = username.value
  pageState.repos = [...repos.value]
  
  // 保存滚动位置
  const container = document.querySelector('.app-container')
  if (container) {
    pageState.scrollTop = container.scrollTop
  }
})
</script>

<style scoped>
.app-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.search-container {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.username-input {
  flex: 1;
  min-width: 200px;
}

.search-btn {
  white-space: nowrap;
}

.repos-container {
  margin-top: 20px;
}

/* 桌面端表格 */
.desktop-table {
  display: block;
}

.desktop-table .repo-link {
  color: #409eff;
  text-decoration: none;
}

.desktop-table .repo-link:hover {
  text-decoration: underline;
}

/* 移动端卡片 */
.mobile-cards {
  display: none;
}

.repo-card {
  background: #fff;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 16px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.repo-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.repo-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
  flex-wrap: wrap;
  gap: 8px;
}

.repo-name {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  flex: 1;
  min-width: 0;
}

.repo-stats {
  display: flex;
  gap: 16px;
  flex-shrink: 0;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #606266;
  font-size: 14px;
}

.repo-description {
  color: #606266;
  margin: 12px 0;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.repo-meta {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 16px;
}

.repo-link {
  color: #409eff;
  text-decoration: none;
  font-size: 14px;
  word-break: break-all;
}

.repo-link:hover {
  text-decoration: underline;
}

.update-time {
  color: #909399;
  font-size: 12px;
}

.empty-state {
  text-align: center;
  margin-top: 60px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .app-container {
    padding: 16px;
  }
  
  .search-container {
    flex-direction: column;
    gap: 16px;
  }
  
  .username-input {
    min-width: 100%;
  }
  
  .search-btn {
    width: 100%;
  }
  
  /* 隐藏桌面端表格，显示移动端卡片 */
  .desktop-table {
    display: none;
  }
  
  .mobile-cards {
    display: block;
  }
  
  .repo-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }
  
  .repo-stats {
    width: 100%;
    justify-content: flex-start;
  }
}

@media (max-width: 480px) {
  .app-container {
    padding: 12px;
  }
  
  .repo-card {
    padding: 12px;
  }
  
  .repo-name {
    font-size: 16px;
  }
  
  .repo-stats {
    gap: 12px;
  }
  
  .stat-item {
    font-size: 13px;
  }
}

/* 平板端优化 */
@media (min-width: 769px) and (max-width: 1024px) {
  .app-container {
    padding: 20px;
    max-width: 100%;
  }
  
  .username-input {
    min-width: 250px;
  }
}

/* 大屏幕优化 */
@media (min-width: 1200px) {
  .app-container {
    max-width: 1400px;
  }
}

/* 加载状态优化 */
.el-loading-mask {
  border-radius: 8px;
}

/* 表格响应式优化 */
@media (max-width: 1200px) {
  .desktop-table .el-table__body-wrapper {
    overflow-x: auto;
  }
}
</style>