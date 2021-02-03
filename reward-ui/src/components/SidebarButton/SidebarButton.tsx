import React from 'react';
import {
    withStyles,
    Theme,
} from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import { purple, grey } from '@material-ui/core/colors';

const SidebarButton = withStyles((theme: Theme) => ({
    root: {
        color: theme.palette.getContrastText(purple[500]),
        backgroundColor: grey[900],
        '&:hover': {
            backgroundColor: grey[800],
        },
        height: '100%',
        padding: 40
    },
}))(Button);

export default SidebarButton;