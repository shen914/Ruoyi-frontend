<template>
  <div class="app-container">
    <el-input v-model="username" placeholder="输入GitHub用户名" style="width: 300px;" />
    <el-button type="primary" @click="fetchRepos" style="margin-left: 10px;">查询仓库</el-button>
    <el-table :data="repos" style="margin-top: 20px;">
      <el-table-column prop="name" label="仓库名" width="160" />
      <el-table-column label="仓库地址" width="250">
        <template #default="scope">
          <a :href="scope.row.html_url" target="_blank" class="repo-link">
            {{ scope.row.full_name }}
          </a>
        </template>
      </el-table-column>
      <el-table-column prop="description" label="描述" width="340" />
      <el-table-column prop="stargazers_count" label="Stars" width="80" align="center" />
      <el-table-column prop="forks_count" label="Forks" width="100" align="center" />
      <el-table-column prop="updated_at" label="更新时间" width="200" />
    </el-table>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { getGithubRepos } from '@/api/system/github'

const username = ref('')
const repos = ref([])

function fetchRepos() {
  if (!username.value) return
  getGithubRepos(username.value).then(res => {
    repos.value = res
  })
}
</script>