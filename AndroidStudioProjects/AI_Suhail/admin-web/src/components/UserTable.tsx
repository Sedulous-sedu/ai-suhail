import React, { useEffect, useState, useMemo } from 'react';
import { DataGrid, GridColDef, GridToolbar, GridRenderCellParams } from '@mui/x-data-grid';
import { IconButton, Tooltip, Typography, Box, Snackbar, Alert, CircularProgress, TextField, InputAdornment } from '@mui/material';
import DeleteIcon from '@mui/icons-material/Delete';
import RefreshIcon from '@mui/icons-material/Refresh';
import SearchIcon from '@mui/icons-material/Search';
import { fetchUsers, deleteUser, User } from '../api';

const UserTable: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [search, setSearch] = useState('');

  const loadUsers = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await fetchUsers();
      setUsers(data);
    } catch (e) {
      setError('Failed to load users.');
    }
    setLoading(false);
  };

  useEffect(() => {
    loadUsers();
  }, []);

  const handleDelete = async (email: string) => {
    try {
      await deleteUser(email);
      setSuccess('User deleted successfully.');
      loadUsers();
    } catch {
      setError('Failed to delete user.');
    }
  };

  const filteredUsers = useMemo(() => {
    if (!search) return users;
    const s = search.toLowerCase();
    return users.filter(
      u => u.name.toLowerCase().includes(s) || u.email.toLowerCase().includes(s) || u.provider.toLowerCase().includes(s)
    );
  }, [users, search]);

  const columns: GridColDef[] = [
    {
      field: 'name',
      headerName: 'Name',
      flex: 1,
      minWidth: 120,
      renderCell: (params: GridRenderCellParams) => (
        <Typography fontWeight={600} color="primary.main">{params.value}</Typography>
      ),
    },
    { field: 'email', headerName: 'Email', flex: 1.5, minWidth: 180 },
    {
      field: 'provider',
      headerName: 'Provider',
      flex: 1,
      minWidth: 100,
      renderCell: (params: GridRenderCellParams) => (
        <Typography color={params.value === 'google' ? 'secondary.main' : 'success.main'} fontWeight={500}>
          {params.value.charAt(0).toUpperCase() + params.value.slice(1)}
        </Typography>
      ),
    },
    {
      field: 'createdAt',
      headerName: 'Created',
      flex: 1,
      minWidth: 140,
      valueFormatter: (params) => new Date(params.value as string).toLocaleString(),
    },
    {
      field: 'actions',
      headerName: '',
      sortable: false,
      filterable: false,
      width: 70,
      renderCell: (params: GridRenderCellParams) => (
        <Tooltip title="Delete User">
          <IconButton color="error" onClick={() => handleDelete(params.row.email)}>
            <DeleteIcon />
          </IconButton>
        </Tooltip>
      ),
    },
  ];

  return (
    <Box>
      <Box display="flex" alignItems="center" mb={2} gap={2}>
        <TextField
          variant="outlined"
          size="small"
          placeholder="Search users..."
          value={search}
          onChange={e => setSearch(e.target.value)}
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon color="primary" />
              </InputAdornment>
            ),
            sx: { bgcolor: 'background.default', borderRadius: 2 },
          }}
        />
        <Tooltip title="Refresh">
          <IconButton color="primary" onClick={loadUsers} disabled={loading}>
            <RefreshIcon />
          </IconButton>
        </Tooltip>
      </Box>
      <Box sx={{ height: 480, width: '100%' }}>
        {loading ? (
          <Box display="flex" alignItems="center" justifyContent="center" height="100%">
            <CircularProgress color="secondary" />
          </Box>
        ) : (
          <DataGrid
            rows={filteredUsers.map((u, i) => ({ id: i, ...u }))}
            columns={columns}
            pageSize={7}
            rowsPerPageOptions={[7, 14, 21]}
            disableRowSelectionOnClick
            autoHeight={false}
            sx={{
              bgcolor: 'background.default',
              color: 'text.primary',
              borderRadius: 2,
              border: 0,
              fontFamily: 'inherit',
              '& .MuiDataGrid-columnHeaders': {
                bgcolor: 'background.paper',
                color: 'primary.main',
                fontWeight: 700,
                fontSize: 16,
              },
              '& .MuiDataGrid-row': {
                transition: 'background 0.2s',
                '&:hover': { bgcolor: 'primary.dark', color: 'secondary.main' },
              },
              '& .MuiDataGrid-cell': {
                fontSize: 15,
              },
            }}
            components={{ Toolbar: GridToolbar }}
          />
        )}
      </Box>
      <Snackbar open={!!error} autoHideDuration={4000} onClose={() => setError(null)}>
        <Alert severity="error" variant="filled" onClose={() => setError(null)}>{error}</Alert>
      </Snackbar>
      <Snackbar open={!!success} autoHideDuration={2500} onClose={() => setSuccess(null)}>
        <Alert severity="success" variant="filled" onClose={() => setSuccess(null)}>{success}</Alert>
      </Snackbar>
    </Box>
  );
};

export default UserTable;

