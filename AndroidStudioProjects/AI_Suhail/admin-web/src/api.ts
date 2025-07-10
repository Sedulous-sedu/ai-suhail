import axios from 'axios';

const API_URL = 'http://localhost:8080/users';

export interface User {
  name: string;
  email: string;
  provider: string;
  createdAt: string;
}

export async function fetchUsers(): Promise<User[]> {
  const res = await axios.get<User[]>(API_URL);
  return res.data;
}

export async function deleteUser(email: string): Promise<void> {
  await axios.delete(API_URL, { data: { email } });
}

