import * as React from 'react';
import { Button } from '@material-ui/core';
import {
    withStyles,
    Theme,
} from '@material-ui/core/styles';
import { grey, purple } from '@material-ui/core/colors';

const TaskbarItem = withStyles((theme: Theme) => ({
    root: {
        color: theme.palette.getContrastText(purple[500]),
        backgroundColor: grey[900],
        '&:hover': {
            backgroundColor: grey[800],
        },
        margin: 3
    },
}))(Button);

export default TaskbarItem;