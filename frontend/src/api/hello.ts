import axios from 'axios'

export async function getHello(): Promise<string> {
  const response = await axios.get<string>(
    'http://localhost:8080/api/v1/hello',
  )

  return response.data
}
