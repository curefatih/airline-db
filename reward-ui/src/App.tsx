import * as React from 'react';
import 'flexiblegs-css';
import './App.css';
import SegmentColumn from './components/SegmentColumn/SegmentColumn';
import SidebarButton from './components/SidebarButton/SidebarButton';
import TaskbarItem from './components/TaskbarItem/TaskbarItem';
import { Button, createStyles, Grow, makeStyles, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, TextField, Theme, Typography, withStyles } from '@material-ui/core';
import Chart from 'react-apexcharts'
import { Delete } from '@material-ui/icons';

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

function App() {
  const classes = useStyles();

  const [customers, setCustomers] = React.useState<any[]>([]);

  const [segments, setSegments] = React.useState([
    {
      minimize: true,
      value: 1,
      title: "Predefined segment",
      header: 'Bronz',
      description: 'Bronz level customers, 1000 > ',
      customers: [] as any[]
    },
    {
      minimize: true,
      value: 1,
      title: "Predefined segment",
      header: 'Silver',
      description: 'Silver level customers, 1000 <=, 5000 >',
      customers: []
    },
    {
      minimize: true,
      value: 1,
      title: "Predefined segment",
      header: 'Gold',
      description: 'Gold level customers, 5000 < ',
      customers: []
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
        position: "" as string,
        points: [] as any[]
      }
    },


  });

  const [refreshCluster, setRefreshCluster] = React.useState(true);
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

    console.log(clusterCentroids, customerCluster);

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
        x: 0,
        y: 0,
        marker: {
          size: 18,
        },
        label: {
          borderColor: '#FF4560',
          text: "c.name"
        }
      })
    })

    setCustomerCluster({
      ...customerCluster,
      series: clusters as any,
      // options: {
      //   ...customerCluster.options,
      //   annotations: {
      //     ...customerCluster.options.annotations,
      //     points: [
      //       {
      //         x: 0,
      //         y: 0,
      //         marker: {
      //           size: 18,
      //         },
      //         label: {
      //           borderColor: '#FF4560',
      //           text: "c.name"
      //         }
      //       }
      //     ]
      //   }
      // }
    })


  }, [refreshCluster, customers])




  React.useEffect(() => {

    const bronzCustomers: any[] = [];
    const silverCustomers: any[] = [];
    const goldCustomers: any[] = [];
    fetch('http://localhost:3000/')
      .then(res => res.json())
      .then((res) => {
        if (Array.isArray(res)) {

          const tCustomer: any[] = [];

          res.map(customer => {
            tCustomer.push({ customer_pn: customer.customer_pn, name: customer.name, y: customer.count, x: customer.point })
            if (customer.point < 200) {
              bronzCustomers.push(customer);
            } else if (customer.point < 5000) {
              silverCustomers.push(customer);
            } else {
              goldCustomers.push(customer);
            }
          })

          setCustomers(tCustomer);
        }
      })

    const tSegments = [...segments];
    tSegments[0].customers = bronzCustomers;
    tSegments[1].customers = silverCustomers;
    tSegments[2].customers = goldCustomers;
    console.log(tSegments);

    setSegments(tSegments)


  }, []);


  // const handleNewSegmentButtonClick = () => {
  //   const tSegments = [...segments];
  //   tSegments.push({
  //     minimize: false,
  //     value: 1,
  //     title: "Custom segment",
  //     header: '*',
  //     description: 'Custom segment customers',
  //     customers: []
  //   });
  //   setSegments(tSegments);
  // }

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

  const handleSegmentDeleteButtonClick = (idx: number) => {
    const tSegment = [...clusterCentroids];
    tSegment.splice(idx, 1);
    setClusterCentroids(tSegment);
  }

  const handleSegmentNameChange = (event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>, idx: number) => {
    const tSegment = [...clusterCentroids];
    tSegment[idx].name = event.target.value;
    setClusterCentroids(tSegment);
  }

  const handleSegmentXChange = (event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>, idx: number) => {
    const tSegment = [...clusterCentroids];
    tSegment[idx].x = parseFloat(event.target.value);
    setClusterCentroids(tSegment);
  }

  const handleSegmentYChange = (event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>, idx: number) => {
    const tSegment = [...clusterCentroids];
    tSegment[idx].y = parseInt(event.target.value);
    setClusterCentroids(tSegment);
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
                        Total record count:{segment.customers.length}
                      </Typography>
                    </div>
                    <TableContainer component={Paper}>
                      <Table className={classes.table} aria-label="customized table">
                        <TableHead>
                          <TableRow>
                            <StyledTableCell>Name</StyledTableCell>
                            <StyledTableCell align="right">Passport number</StyledTableCell>
                            <StyledTableCell align="right">Email</StyledTableCell>
                            <StyledTableCell align="right">Country</StyledTableCell>
                            <StyledTableCell align="right">Point</StyledTableCell>
                          </TableRow>
                        </TableHead>
                        <TableBody>
                          {segment.customers.map((customer) => {
                            return (
                              <StyledTableRow key={customer.customer_pn}>
                                <StyledTableCell component="th" scope="row">
                                  {customer.name}
                                </StyledTableCell>
                                <StyledTableCell align="right">{customer.customer_pn}</StyledTableCell>
                                <StyledTableCell align="right">{customer.email}</StyledTableCell>
                                <StyledTableCell align="right">{customer.country}</StyledTableCell>
                                <StyledTableCell align="right">{customer.point}</StyledTableCell>
                              </StyledTableRow>
                            )
                          })}
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
                onRefresh={() => { setRefreshCluster(!refreshCluster) }}
              >
                <div id="chart">
                  <Chart options={customerCluster.options} series={customerCluster.series} type="scatter" height={350} />
                </div>

                <div className="segments">
                  {clusterCentroids.map((cc, i) => {
                    return <div className="segment" key={i}>
                      <form noValidate autoComplete="off" key={i}>
                        <div className="wrap xl-flexbox xl-middle">
                          <div
                            style={{
                              flex: 1
                            }}
                            className="col">
                            <TextField className={classes.segmentInput} classes={{ root: 'segment-input' }} label="Name" variant="outlined" value={cc.name} onChange={(e) => handleSegmentNameChange(e, i)} />
                          </div>
                          <div className="col">
                            <TextField className={classes.segmentNumberInput} label="X" variant="outlined" type='number' value={cc.x} onChange={(e) => handleSegmentXChange(e, i)} />
                          </div>
                          <div className="col">
                            <TextField className={classes.segmentNumberInput} label="Y" variant="outlined" type='number' value={cc.y} onChange={(e) => handleSegmentYChange(e, i)} />
                          </div>
                          <div className="col">
                            <Button color='secondary' onClick={() => handleSegmentDeleteButtonClick(i)}><Delete /></Button>
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
          {/* <div className="col">
            <SidebarButton
              onClick={handleNewSegmentButtonClick}>
              New segment
  </SidebarButton>
          </div> */}


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
