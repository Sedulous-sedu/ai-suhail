import { createTheme } from '@mui/material/styles';

// Dracula color palette
const dracula = {
  background: '#282a36',
  currentLine: '#44475a',
  foreground: '#f8f8f2',
  comment: '#6272a4',
  cyan: '#8be9fd',
  green: '#50fa7b',
  orange: '#ffb86c',
  pink: '#ff79c6',
  purple: '#bd93f9',
  red: '#ff5555',
  yellow: '#f1fa8c',
};

const theme = createTheme({
  palette: {
    mode: 'dark',
    background: {
      default: dracula.background,
      paper: dracula.currentLine,
    },
    primary: {
      main: dracula.purple,
      contrastText: dracula.foreground,
    },
    secondary: {
      main: dracula.cyan,
      contrastText: dracula.background,
    },
    error: {
      main: dracula.red,
    },
    warning: {
      main: dracula.orange,
    },
    info: {
      main: dracula.cyan,
    },
    success: {
      main: dracula.green,
    },
    text: {
      primary: dracula.foreground,
      secondary: dracula.comment,
    },
  },
  typography: {
    fontFamily: 'JetBrains Mono, Fira Mono, monospace',
    h1: { fontWeight: 700 },
    h2: { fontWeight: 700 },
    h3: { fontWeight: 700 },
    h4: { fontWeight: 700 },
    h5: { fontWeight: 700 },
    h6: { fontWeight: 700 },
  },
  components: {
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: 'none',
        },
      },
    },
  },
});

export default theme;

