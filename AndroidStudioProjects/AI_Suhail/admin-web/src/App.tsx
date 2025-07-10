import React from 'react';
import { ThemeProvider, CssBaseline, AppBar, Toolbar, Typography, Container, Box } from '@mui/material';
import PeopleAltIcon from '@mui/icons-material/PeopleAlt';
import theme from './theme';
import UserTable from './components/UserTable';

const App: React.FC = () => {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <AppBar position="static" color="primary" elevation={2}>
        <Toolbar>
          <PeopleAltIcon sx={{ mr: 2, fontSize: 32 }} />
          <Typography variant="h5" sx={{ fontWeight: 700, letterSpacing: 1 }}>
            AI Toolbox Admin
          </Typography>
        </Toolbar>
      </AppBar>
      <Container maxWidth="md" sx={{ mt: 6, mb: 4 }}>
        <Box sx={{ bgcolor: 'background.paper', borderRadius: 3, p: { xs: 2, sm: 4 }, boxShadow: 6 }}>
          <UserTable />
        </Box>
      </Container>
    </ThemeProvider>
  );
};

export default App;

