import request from '@/utils/request'

// 获取GitHub仓库列表
export function getGithubRepos(username) {
  return request({
    url: '/system/github/repos',
    method: 'get',
    params: { username }
  })
}