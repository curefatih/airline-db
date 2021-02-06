import * as React from 'react';
import './SegmentColumn.css';
import { makeStyles, withStyles } from '@material-ui/core/styles';
import Card from '@material-ui/core/Card';
import CardActions from '@material-ui/core/CardActions';
import CardContent from '@material-ui/core/CardContent';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import MinimizeIcon from '@material-ui/icons/Minimize';
import AspectRatioRoundedIcon from '@material-ui/icons/AspectRatioRounded';
import RefreshIcon from '@material-ui/icons/Refresh';
export interface SegmentColumnProps extends React.HTMLAttributes<HTMLDivElement> {
    onMinimizeFired?: () => void,
    onRefresh?: () => void,
    title: string,
    header: string,
    description: string,
}

const useStyles = makeStyles({
    root: {
        width: 275,
        height: '100%',
        transition: '1s ease all'
    },

    bullet: {
        display: 'inline-block',
        margin: '0 2px',
        transform: 'scale(0.8)',
    },
    title: {
        fontSize: 14,
    },
    pos: {
        marginBottom: 12,
    },
});

const ActionButton = withStyles({
    root: {
        minWidth: 'unset',
        padding: 3,
        marginLeft: 3
    }
})(Button)

const SegmentColumn: React.FunctionComponent<SegmentColumnProps> = (props: SegmentColumnProps) => {
    const classes = useStyles();


    const [state, setState] = React.useState({
        expanded: false
    });

    const handleMinimize = () => {
        if (props.onMinimizeFired) props.onMinimizeFired()
    }

    const handleMaximize = () => {
        setState({
            ...state,
            expanded: !state.expanded
        })
    }

    const handleRefresh = () => {
        if(props.onRefresh) props.onRefresh()
    }


    return (

        <Card
            className={classes.root}
            classes={{
                root: !state.expanded ? 'root' : 'rootExpanded'
            }}
        >
            <CardContent classes={{ root: 'card-content' }}>
                <div
                    style={{
                        padding: 3
                    }}
                    className="actions xl-right">
                    {props.onRefresh ?
                        <ActionButton
                            variant="outlined"
                            onClick={handleRefresh}
                        ><RefreshIcon /></ActionButton> : null}
                    <ActionButton
                        variant="outlined"
                        onClick={handleMaximize}
                    ><AspectRatioRoundedIcon /></ActionButton>
                    <ActionButton
                        variant="outlined"
                        onClick={handleMinimize}
                    ><MinimizeIcon /></ActionButton>

                </div>
                <Typography className={classes.title} color="textSecondary" gutterBottom>
                    {props.title}
                </Typography>
                <Typography variant="h5" component="h2">
                    {props.header}
                </Typography>
                <Typography className={classes.pos} color="textSecondary">
                    {props.description}
                </Typography>
                {props.children}
            </CardContent>
            <CardActions>
                <Button size="small">Learn More</Button>
            </CardActions>
        </Card>
    );
}

export default SegmentColumn;