import * as React from 'react';
import 'flexiblegs-css';
import './App.css';
import SegmentColumn from './components/SegmentColumn/SegmentColumn';
import SidebarButton from './components/SidebarButton/SidebarButton';
import TaskbarItem from './components/TaskbarItem/TaskbarItem';
import { Button, createStyles, Grow, makeStyles, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, TextField, Theme, Typography, withStyles } from '@material-ui/core';
import Chart from 'react-apexcharts'
import Input from '@material-ui/core/Input';
import { Delete } from '@material-ui/icons';


const rows = [
  createData('Frozen yoghurt', 159, 6.0, 24, 4.0),
  createData('Ice cream sandwich', 237, 9.0, 37, 4.3),
  createData('Eclair', 262, 16.0, 24, 6.0),
  createData('Cupcake', 305, 3.7, 67, 4.3),

];

const StyledTableCell = withStyles((theme: Theme) =>
  createStyles({
    head: {
      backgroundColor: theme.palette.common.black,
      color: theme.palette.common.white,
    },
    body: {
      fontSize: 14,
    },
  }),
)(TableCell);

const StyledTableRow = withStyles((theme: Theme) =>
  createStyles({
    root: {
      '&:nth-of-type(odd)': {
        backgroundColor: theme.palette.action.hover,
      },
    },
  }),
)(TableRow);



const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    table: {
      minWidth: 700,
    },
    pos: {
      marginBottom: 12,
    },
    segmentInput: {
      '& > *': {
        margin: theme.spacing(1),
        width: '100%',
      },
    },
    segmentNumberInput: {
      '& > *': {
        margin: theme.spacing(1),
        width: '10ch',
      },
    },
  })
);

function createData(name: string, calories: number, fat: number, carbs: number, protein: number) {
  return { name, calories, fat, carbs, protein };
}

const customers = [
  { x: 16.4, y: 5.4, name: "customer_name" },
  { x: 21.7, y: 2, name: "customer_name" },
  { x: 25.4, y: 3, name: "customer_name" },
  { x: 19, y: 2, name: "customer_name" },
  { x: 10.9, y: 1, name: "customer_name" },
  { x: 13.6, y: 3.2, name: "customer_name" },
  { x: 10.9, y: 7.4, name: "customer_name" },
  { x: 10.9, y: 0, name: "customer_name" },
  { x: 10.9, y: 8.2, name: "customer_name" },
  { x: 16.4, y: 0, name: "customer_name" },
  { x: 16.4, y: 1.8, name: "customer_name" },
  { x: 13.6, y: 0.3, name: "customer_name" },
  { x: 13.6, y: 0, name: "customer_name" },
  { x: 29.9, y: 0, name: "customer_name" },
  { x: 27.1, y: 2.3, name: "customer_name" },
  { x: 16.4, y: 0, name: "customer_name" },
  { x: 13.6, y: 3.7, name: "customer_name" },
  { x: 10.9, y: 5.2, name: "customer_name" },
  { x: 16.4, y: 6.5, name: "customer_name" },
  { x: 10.9, y: 0, name: "customer_name" },
  { x: 24.5, y: 7.1, name: "customer_name" },
  { x: 10.9, y: 0, name: "customer_name" },
  { x: 8.1, y: 4.7, name: "customer_name" },
  { x: 19, y: 0, name: "customer_name" },
  { x: 21.7, y: 1.8, name: "customer_name" },
  { x: 27.1, y: 0, name: "customer_name" },
  { x: 24.5, y: 0, name: "customer_name" },
  { x: 27.1, y: 0, name: "customer_name" },
  { x: 29.9, y: 1.5, name: "customer_name" },
  { x: 27.1, y: 0.8, name: "customer_name" },
  { x: 22.1, y: 2, name: "customer_name" },
  { x: 36.4, y: 13.4, name: "customer_name" },
  { x: 1.7, y: 11, name: "customer_name" },
  { x: 5.4, y: 8, name: "customer_name" },
  { x: 9, y: 17, name: "customer_name" },
  { x: 1.9, y: 4, name: "customer_name" },
  { x: 3.6, y: 12.2, name: "customer_name" },
  { x: 1.9, y: 14.4, name: "customer_name" },
  { x: 1.9, y: 9, name: "customer_name" },
  { x: 1.9, y: 13.2, name: "customer_name" },
  { x: 1.4, y: 7, name: "customer_name" },
  { x: 6.4, y: 8.8, name: "customer_name" },
  { x: 3.6, y: 4.3, name: "customer_name" },
  { x: 1.6, y: 10, name: "customer_name" },
  { x: 9.9, y: 2, name: "customer_name" },
  { x: 7.1, y: 15, name: "customer_name" },
  { x: 1.4, y: 0, name: "customer_name" },
  { x: 3.6, y: 13.7, name: "customer_name" },
  { x: 1.9, y: 15.2, name: "customer_name" },
  { x: 6.4, y: 16.5, name: "customer_name" },
  { x: 0.9, y: 10, name: "customer_name" },
  { x: 4.5, y: 17.1, name: "customer_name" },
  { x: 10.9, y: 10, name: "customer_name" },
  { x: 0.1, y: 14.7, name: "customer_name" },
  { x: 9, y: 10, name: "customer_name" },
  { x: 12.7, y: 11.8, name: "customer_name" },
  { x: 2.1, y: 10, name: "customer_name" },
  { x: 2.5, y: 10, name: "customer_name" },
  { x: 27.1, y: 10, name: "customer_name" },
  { x: 2.9, y: 11.5, name: "customer_name" },
  { x: 7.1, y: 10.8, name: "customer_name" },
  { x: 2.1, y: 12, name: "customer_name" },
  { x: 21.7, y: 3, name: "customer_name" },
  { x: 23.6, y: 3.5, name: "customer_name" },
  { x: 24.6, y: 3, name: "customer_name" },
  { x: 29.9, y: 3, name: "customer_name" },
  { x: 21.7, y: 20, name: "customer_name" },
  { x: 23, y: 2, name: "customer_name" },
  { x: 10.9, y: 3, name: "customer_name" },
  { x: 28, y: 4, name: "customer_name" },
  { x: 27.1, y: 0.3, name: "customer_name" },
  { x: 16.4, y: 4, name: "customer_name" },
  { x: 13.6, y: 0, name: "customer_name" },
  { x: 19, y: 5, name: "customer_name" },
  { x: 22.4, y: 3, name: "customer_name" },
  { x: 24.5, y: 3, name: "customer_name" },
  { x: 32.6, y: 3, name: "customer_name" },
  { x: 27.1, y: 4, name: "customer_name" },
  { x: 29.6, y: 6, name: "customer_name" },
  { x: 31.6, y: 8, name: "customer_name" },
  { x: 21.6, y: 5, name: "customer_name" },
  { x: 20.9, y: 4, name: "customer_name" },
  { x: 22.4, y: 0, name: "customer_name" },
  { x: 32.6, y: 10.3, name: "customer_name" },
  { x: 29.7, y: 20.8, name: "customer_name" },
  { x: 24.5, y: 0.8, name: "customer_name" },
  { x: 21.4, y: 0, name: "customer_name" },
  { x: 21.7, y: 6.9, name: "customer_name" },
  { x: 28.6, y: 7.7, name: "customer_name" },
  { x: 15.4, y: 0, name: "customer_name" },
  { x: 18.1, y: 0, name: "customer_name" },
  { x: 33.4, y: 0, name: "customer_name" },
  { x: 16.4, y: 0, name: "customer_name" }
];


function App() {
  const classes = useStyles();

  const [segments, setSegments] = React.useState([
    {
      minimize: false,
      value: 1,
      title: "Predefined segment",
      header: 'Bronz',
      description: 'Bronz level customers'
    },
    {
      minimize: false,
      value: 1,
      title: "Predefined segment",
      header: 'Silver',
      description: 'Silver level customers'
    },
    {
      minimize: false,
      value: 1,
      title: "Predefined segment",
      header: 'Gold',
      description: 'Gold level customers',
    },
  ]);

  const [customerCluster, setCustomerCluster] = React.useState({

    series: [],
    options: {
      chart: {
        height: 500,
        type: 'scatter',
        zoom: {
          enabled: true,
          type: 'xy'
        }
      },
      xaxis: {
        tickAmount: 10,
        labels: {
          formatter: function (val: string) {
            return parseFloat(val).toFixed(1)
          }
        }
      },
      yaxis: {
        tickAmount: 7
      },
      annotations: {
        points: []
      }
    },


  });

  const [clusterCentroids, setClusterCentroids] = React.useState([
    {
      name: "c1",
      x: 3.7,
      y: 12
    },
    {
      name: "c2",
      x: 18.2,
      y: 3
    },
    {
      name: "c3",
      x: 29.8,
      y: 6
    }
  ]);


  React.useEffect(() => {
    // {
    //   name: "SAMPLE A",
    //     data: []
    // }
    const clusters: { name: string, type?: string, data: any[]; }[] = []
    clusterCentroids.map((cluster) => clusters.push({ name: cluster.name, type: 'scatter', data: [] }))
    customers.map((customer) => {
      let min = -1;
      let minIndex = -1;

      // find nearest centroid
      clusterCentroids.forEach((cluster, i) => {
        const distance = Math.pow(cluster.x - customer.x, 2) + Math.pow(cluster.y - customer.y, 2)
        if (min > distance || minIndex === -1) {
          min = distance;
          minIndex = i;
        }
      })

      // save as
      const currentData = clusters[minIndex].data;
      currentData.push(customer)
      clusters[minIndex].data = [...currentData];
    })

    const clusterPoints: { x: number; y: number; marker: { size: number; }; label: { borderColor: string; text: string; }; }[] = [];
    clusterCentroids.map((c) => {
      clusterPoints.push({
        x: c.x,
        y: c.y,
        marker: {
          size: 8,
        },
        label: {
          borderColor: '#FF4560',
          text: c.name
        }
      })
    })

    setCustomerCluster({
      ...customerCluster,
      series: clusters as any,
      options: {
        ...customerCluster.options,
        annotations: {
          points: clusterPoints as any
        }
      }
    })

  }, [clusterCentroids])

  const handleNewSegmentButtonClick = () => {
    const tSegments = [...segments];
    tSegments.push({
      minimize: false,
      value: 1,
      title: "Custom segment",
      header: '*',
      description: 'Custom segment customers'
    });
    setSegments(tSegments);
  }

  const handleMinimize = (idx: number) => {
    const tSegments = [...segments];
    tSegments[idx].minimize = true;
    setSegments(tSegments);
  }

  const handleMaximize = (idx: number) => {
    const tSegments = [...segments];
    tSegments[idx].minimize = false;
    setSegments(tSegments);
  }

  const handleNewClusterCentroid = () => {
    const tCentroids = [...clusterCentroids];
    tCentroids.push({ name: '?', x: 0, y: 0 });
    setClusterCentroids(tCentroids);
  }

  return (
    <div className="app">

      <div className="container">
        <div className="wrap xl-flexbox columns">

          {/*  Left side for segments */}
          {segments.map((segment, i) =>
            <Grow
              unmountOnExit
              in={!segment.minimize}
              // style={{ transformOrigin: '0 0 0' }}
              {...({ timeout: 1000 })}
              key={i}
            >
              <div className="col" key={i}>
                <SegmentColumn
                  title={segment.title}
                  header={segment.header}
                  description={segment.description}
                  onMinimizeFired={() => handleMinimize(i)}>
                  <div
                    className="table">
                    <div className="xl-right">
                      <Typography className={classes.pos} color="textSecondary">
                        Total record count:{rows.length}
                      </Typography>
                    </div>
                    <TableContainer component={Paper}>
                      <Table className={classes.table} aria-label="customized table">
                        <TableHead>
                          <TableRow>
                            <StyledTableCell>Dessert (100g serving)</StyledTableCell>
                            <StyledTableCell align="right">Calories</StyledTableCell>
                            <StyledTableCell align="right">Fat&nbsp;(g)</StyledTableCell>
                            <StyledTableCell align="right">Carbs&nbsp;(g)</StyledTableCell>
                            <StyledTableCell align="right">Protein&nbsp;(g)</StyledTableCell>
                          </TableRow>
                        </TableHead>
                        <TableBody>
                          {rows.map((row) => (
                            <StyledTableRow key={row.name}>
                              <StyledTableCell component="th" scope="row">
                                {row.name}
                              </StyledTableCell>
                              <StyledTableCell align="right">{row.calories}</StyledTableCell>
                              <StyledTableCell align="right">{row.fat}</StyledTableCell>
                              <StyledTableCell align="right">{row.carbs}</StyledTableCell>
                              <StyledTableCell align="right">{row.protein}</StyledTableCell>
                            </StyledTableRow>
                          ))}
                        </TableBody>
                      </Table>
                    </TableContainer>
                  </div>
                </SegmentColumn>
              </div>
            </Grow>
          )}

          <Grow
            unmountOnExit
            in={true}
            // style={{ transformOrigin: '0 0 0' }}
            {...({ timeout: 1000 })}
          >
            <div className="col">
              <SegmentColumn
                title='Predefined segments'
                header='KMeans'
                description=""
                onMinimizeFired={() => { }}
              >
                <div id="chart">
                  <Chart options={customerCluster.options} series={customerCluster.series} type="scatter" height={350} />
                </div>
                <div className="segments">
                  {clusterCentroids.map((cc, i) => {
                    return <div className="segment">
                      <form noValidate autoComplete="off" key={i}>
                        <div className="wrap xl-flexbox xl-middle">
                          <div 
                          style={{
                            flex: 1
                          }}
                          className="col">
                            <TextField className={classes.segmentInput} classes={{root: 'segment-input'}} label="Name" variant="outlined" value={cc.name} />
                          </div>
                          <div className="col">
                            <TextField className={classes.segmentNumberInput} label="X" variant="outlined" value={cc.x} />
                          </div>
                          <div className="col">
                            <TextField className={classes.segmentNumberInput} label="Y" variant="outlined" value={cc.y} />
                          </div>
                          <div className="col">
                            <Button color='secondary'><Delete /></Button>
                          </div>
                        </div>
                      </form>
                    </div>
                  })}
                  <Button
                    style={{
                      marginTop: '1em'
                    }}
                    onClick={handleNewClusterCentroid}
                    color='primary' variant="contained" >Add new centroid</Button>
                </div>
              </SegmentColumn>
            </div>
          </Grow>



          {/* Right button for adding new segment */}
          <div className="col">
            <SidebarButton
              onClick={handleNewSegmentButtonClick}>
              New segment
  </SidebarButton>
          </div>


        </div>

        <div className="taskbar xl-left">
          {
            segments.map((task, i) =>
              task.minimize &&
              <TaskbarItem
                variant="outlined"
                onClick={() => handleMaximize(i)}
                key={i}>
                {task.header}
              </TaskbarItem>
            )
          }
        </div>
      </div>


    </div >
  );
}

export default App;
