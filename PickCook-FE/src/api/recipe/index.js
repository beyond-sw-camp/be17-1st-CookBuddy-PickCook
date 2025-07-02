import api from '@/plugins/axiosinterceptor'

const recipeList = async () => {
  let data = {}
  let url = '/recipe.json'

  await api
    .get(url)
    .then((res) => {
      data = res.data
    })
    .catch((error) => {
      data = error.data
    })

  return data
}

export default { recipeList }
