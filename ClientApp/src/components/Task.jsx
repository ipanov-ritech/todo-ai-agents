import { connect } from 'react-redux';
import { Button, Form } from 'react-bootstrap';
import { deleteTask, toggleComplete } from '../features/taskList/actions';

const TaskRaw = (props) => (
  <tr>
    <td>
      <Form.Check
        type="checkbox"
        checked={props.data.isCompleted || false}
        onChange={() => props.toggleComplete(props.data.id)}
        aria-label={`Mark task ${props.data.id} as complete`}
      />
    </td>
    <td>{props.data.id}</td>
    <td style={props.data.isCompleted ? { textDecoration: 'line-through', color: '#6c757d' } : {}}>
      {props.data.description}
    </td>
    <td>
      <Button variant="danger" onClick={() => props.deleteTask(props.data.id)}>
        Delete
      </Button>
    </td>
  </tr>
);

const actionCreators = { deleteTask, toggleComplete };

export const Task = connect(null, actionCreators)(TaskRaw);
